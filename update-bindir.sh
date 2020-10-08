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

fetch and_rename nvim 1eea3d44f55bab0856d08737c0c50ead7645ae3afd6352a252bc403b9843ec95 \
  "https://github.com/neovim/neovim/releases/download/v0.4.4/nvim.appimage"
fetch and_extract fzf 477b52457d185e4c7e9b225e62bd11a7fcff5a8105a13408742b953724e98885 \
  "https://github.com/junegunn/fzf-bin/releases/download/0.23.0/fzf-0.23.0-linux_amd64.tgz"
fetch and_extract texlab e9ecf0a07e42180f77aa85a87fcc6690a34af8b631c6bb22101986df87043658 \
  "https://github.com/latex-lsp/texlab/releases/download/v2.2.0/texlab-x86_64-linux.tar.gz"
