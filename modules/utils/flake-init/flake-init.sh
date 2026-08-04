# shellcheck shell=bash

if [[ -e flake.nix ]]; then
  echo "flake-init: flake.nix already exists in $PWD" >&2
  exit 1
fi

cat "$TEMPLATE" >flake.nix
echo "flake-init: wrote $PWD/flake.nix"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "flake-init: remember to 'git add flake.nix' so nix can see it"
fi
