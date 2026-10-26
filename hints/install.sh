#!/usr/bin/env bash
# Links this repo's hints config to ~/.config/hints/config.json (the path hints reads),
# moving any existing file aside to config.json.bak first.
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/config.json"
dest="$HOME/.config/hints/config.json"

mkdir -p "$(dirname "$dest")"
if [ -e "$dest" ] && [ ! -L "$dest" ]; then
  mv "$dest" "$dest.bak"
  echo "Moved existing config to $dest.bak"
fi
ln -sfn "$src" "$dest"
echo "Linked $dest -> $src"
