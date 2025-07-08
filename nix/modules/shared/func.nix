{
  mkShellConfig = {
    pref ? "",
    list ? [],
    attrSet ? {},
    sep ? " ",
    term ? "\n",
    qKey ? false,
    qVal ? false,
    qPref ? false,
  }: let
    lib = import <nixpkgs/lib>;
    concatStringsSep = sep: list: lib.concatStringsSep sep (lib.filter (x: x != "") list);
    quote = s: ''"${s}"'';
    fmtPrefix =
      if qPref
      then quote pref
      else pref;
  in
    concatStringsSep term [
      (concatStringsSep term (lib.lists.forEach list (x:
        fmtPrefix
        + (
          if qVal
          then quote x
          else x
        ))))
      (concatStringsSep term (lib.mapAttrsToList (k: v:
        fmtPrefix
        + (
          if qKey
          then quote k
          else k
        )
        + sep
        + (
          if qVal
          then quote v
          else v
        ))
      attrSet))
    ];
}
# { keyword, separator, quoteValue, kvp, quoteKeyIfSpecial ? false, terminator ? "\n" }:
# pkgs.lib.concatStringsSep "${terminator}" (pkgs.lib.mapAttrsToList (n: v:
#             let
#             isSimpleIdentifier = pkgs.lib.match "[a-zA-Z0-9_]+" n == [ n ];
#             finalKey = if quoteKeyIfSpecial && !isSimpleIdentifier
#             then ''"${n}"''
#             else if keyword == "bindkey" && !(n == "Backspace" || n == "Delete" || n == "Enter" || n == "Tab" || n == "Space")
#             then ''"${n}"''
#             else n;
#             valuePart = if quoteValue then ''"${v}"'' else v;
#             in
#             ''${keyword}${finalKey}${separator}${valuePart}''
#             ) kvp);

