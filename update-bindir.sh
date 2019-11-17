#!/bin/sh -e

# This script populates and updates the bin/ directory with 64-Bit linux
# binaries.

check_hash()
(
  filename="$1"
  sha256="$2"

  printf "%s %s\n" "$sha256" "$filename" | sha256sum -c -
)

fetch()
(
  process_download_callback="$1"
  filename="$2"
  sha256="$3"
  url="$4"

  if check_hash "$filename" "$sha256" >/dev/null 2>&1; then
    printf "Already up-to-date: %s\n" "$filename"
    return
  fi

  printf "Fetching %s...\n" "$filename"
  trap 'rm -f .tmp_download' EXIT
  wget --show-progress --quiet "$url" -O .tmp_download

  "$process_download_callback" .tmp_download "$filename" "$sha256"
  chmod +x "$filename"
)

and_rename()
(
  download="$1"
  filename="$2"
  sha256="$3"

  check_hash "$download" "$sha256"
  mv "$download" "$filename"
)

and_extract()
(
  archive="$1"
  filename="$2"
  sha256="$3"

  trap 'rm -f ".tmp__$filename"' EXIT
  tar xaf "$archive" "$filename" -O > ".tmp__$filename"
  check_hash ".tmp__$filename" "$sha256"

  mv ".tmp__$filename" "$filename"
)

cd "$(dirname "$0")"
mkdir -p bin
cd bin/

fetch and_rename nvim a3b7ccbde583acdc7f3385025d3c5e386f92aa97e425b311a49402836998b4e0 \
  "https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage"
fetch and_extract fzf cc0a4a04ec7d892d68ebe4db7c70c0b4130848b9a17f99b02b254238f7db6a44 \
  "https://github.com/junegunn/fzf-bin/releases/download/0.19.0/fzf-0.19.0-linux_amd64.tgz"
fetch and_extract texlab b17e05b429186cced7d81c7fb616a84bae69a111f669179f6bddb78707324cbf \
  "https://github.com/latex-lsp/texlab/releases/download/v1.6.0/texlab-x86_64-linux.tar.gz"
