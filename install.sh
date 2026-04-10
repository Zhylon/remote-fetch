#!/usr/bin/env bash
# curl -fsSL https://raw.githubusercontent.com/zhylon/remote-fetch/main/install.sh | bash
set -euo pipefail
REPO="zhylon/remote-fetch"
RAW="https://raw.githubusercontent.com/${REPO}/main/remote-fetch"
DEST="${PREFIX:-/usr/local/bin}/remote-fetch"

for dep in ssh rsync tar curl; do
  command -v "$dep" >/dev/null || { echo "missing dependency: $dep" >&2; exit 1; }
done

tmp="$(mktemp)"
echo "==> downloading remote-fetch"
curl -fsSL "$RAW" -o "$tmp"
chmod +x "$tmp"

if [[ -w "$(dirname "$DEST")" ]]; then
  install -m 0755 "$tmp" "$DEST"
else
  sudo install -m 0755 "$tmp" "$DEST"
fi
rm -f "$tmp"

echo "ok: installed -> $DEST"
"$DEST" --version
echo "next: remote-fetch config add myserver && remote-fetch config edit"
