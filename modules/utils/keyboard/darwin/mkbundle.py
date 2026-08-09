#!/usr/bin/env python3
"""Assemble a macOS .bundle of keyboard layouts from KLFC output.

Does the three things KLFC cannot do itself:

1. ANSI retargeting. KLFC emits the top-left key at code 10 (kVK_ISO_Section)
   and the ISO key next to left shift at code 50 (kVK_ANSI_Grave). That suits
   ISO boards but not ANSI ones, where the top-left key *is* code 50 and the
   ISO key is absent - klfc issue #42, whose author describes ANSI as "the ISO
   keyboard, but with the Tilde and Iso keys swapped and then the Iso key
   removed". So for ANSI layouts: drop code 50, then move code 10 onto it.

2. Unique layout ids. KLFC hardcodes id="-1337", so three layouts in one
   bundle would collide. Ids come from the config and deliberately reuse the
   previous Ukelele ones, which keeps macOS from seeing them as new input
   sources and forgetting which are enabled.

3. The bundle itself: Info.plist with one KLInfo_<name> entry per layout.

Config is JSON: {"identifier":..., "bundleName":..., "layouts":[
  {"name":..., "src":..., "id":..., "language":..., "ansi":bool}, ...]}
"""

import json
import os
import plistlib
import re
import shutil
import sys


def to_ansi(text):
    out, dropped, moved = [], 0, 0
    for line in text.split("\n"):
        if re.search(r'<key\s+code="50"', line):
            dropped += 1
            continue
        if re.search(r'<key\s+code="10"', line):
            out.append(line.replace('code="10"', 'code="50"', 1))
            moved += 1
            continue
        out.append(line)
    if not moved:
        raise SystemExit("ANSI fix: no code=10 keys found, refusing silent no-op")
    return "\n".join(out), dropped, moved


def main():
    cfg = json.load(open(sys.argv[1], encoding="utf-8"))
    out = sys.argv[2]

    res = os.path.join(out, "Contents", "Resources")
    os.makedirs(res, exist_ok=True)

    info = {
        "CFBundleIdentifier": cfg["identifier"],
        "CFBundleName": cfg["bundleName"],
        "CFBundleVersion": cfg.get("version", "1.0"),
    }

    for spec in cfg["layouts"]:
        with open(spec["src"], encoding="utf-8") as f:
            text = f.read()

        if spec.get("ansi"):
            text, dropped, moved = to_ansi(text)
            print(f"  {spec['name']}: ANSI (-{dropped} Iso, {moved} -> code 50)")
        else:
            print(f"  {spec['name']}: ISO (unchanged)")

        # KLFC hardcodes id="-1337"; give each layout its own.
        text, n = re.subn(
            r'(<keyboard\b[^>]*\bid=")-?\d+(")',
            rf"\g<1>{spec['id']}\g<2>",
            text,
            count=1,
        )
        if n != 1:
            raise SystemExit(f"{spec['name']}: could not rewrite layout id")

        with open(
            os.path.join(res, f"{spec['name']}.keylayout"), "w", encoding="utf-8"
        ) as f:
            f.write(text)

        slug = spec["name"].lower().replace(" ", "").replace("-", "")
        info[f"KLInfo_{spec['name']}"] = {
            "TICapsLockLanguageSwitchCapable": False,
            "TISIconIsTemplate": False,
            "TISInputSourceID": f"{cfg['identifier']}.{slug}",
            "TISIntendedLanguage": spec["language"],
        }

    with open(os.path.join(out, "Contents", "Info.plist"), "wb") as f:
        plistlib.dump(info, f)

    # Icons are optional; carry them over when the caller supplies some.
    for icon in cfg.get("icons", []):
        shutil.copy(icon, res)


if __name__ == "__main__":
    main()
