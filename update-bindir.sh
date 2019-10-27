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

  printf "SUCCESS: %s\n" "$filename"
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

mkdir -p "$HOME/.config/nvim/bin"
cd "$HOME/.config/nvim/bin"

fetch and_rename nvim 58ef252e4b26b5589d0f5024952004557196dcbe0cec1674985e1ad591d8b5aa \
  "https://github.com/neovim/neovim/releases/download/v0.4.2/nvim.appimage"
fetch and_extract fzf 076e7cc001afa08d74ebed9c6edfd98bcbf58b8a107fd640dd72aeb4dba54eef \
  "https://github.com/junegunn/fzf-bin/releases/download/0.18.0/fzf-0.18.0-linux_amd64.tgz"
