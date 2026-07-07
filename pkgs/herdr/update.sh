#!/usr/bin/env bash
# default.nix の version に対応する各プラットフォームのリリースアセットを
# nix store prefetch-file で取得し、sources 内の hash をすべて更新する。
# nix-update はホスト以外のシステムの hash を更新できない
# (対象システムの derivation をビルドできない) ため、このスクリプトで補完する。
set -euo pipefail
cd "$(dirname "$0")"

version=$(grep -m1 'version = ' default.nix | sed 's/.*"\(.*\)".*/\1/')

grep -o 'asset = "[^"]*"' default.nix | cut -d'"' -f2 | while read -r asset; do
  url="https://github.com/ogulcancelik/herdr/releases/download/v${version}/${asset}"
  hash=$(nix store prefetch-file --json "$url" | jq -r '.hash')
  awk -v asset="$asset" -v hash="$hash" '
    /asset = "/ { in_target = index($0, "\"" asset "\"") > 0 }
    in_target && /hash = "/ { sub(/"[^"]*"/, "\"" hash "\""); in_target = 0 }
    { print }
  ' default.nix > default.nix.tmp && mv default.nix.tmp default.nix
  echo "updated ${asset}: ${hash}"
done
