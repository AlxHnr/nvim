#!/bin/sh -e

# This script populates and updates the bin/ directory with 64-Bit linux
# binaries.

check_hash()
(
  filename="$1"
  expected_sha256="$2"

  sha256sum=$(sha256sum "$filename" | grep -oE '^\S+')
  test "$sha256sum" = "$expected_sha256" || {
    printf "error: sha256 mismatch\n"
    printf "  expected: %s\n" "$expected_sha256"
    printf "  got:      %s\n" "$sha256sum"
    return 1
  } >&2
)

fetch()
(
  process_download_callback="$1"
  filename="$2"
  expected_sha256="$3"
  url="$4"

  if check_hash "$filename" "$expected_sha256" >/dev/null 2>&1; then
    printf "Already up-to-date: %s\n" "$filename"
    return
  fi

  printf "Fetching %s...\n" "$filename"
  trap 'rm -f .tmp_download' EXIT
  wget --show-progress --quiet "$url" -O .tmp_download

  "$process_download_callback" .tmp_download "$filename" "$expected_sha256"
  chmod +x "$filename"
)

and_rename()
(
  download="$1"
  filename="$2"
  expected_sha256="$3"

  check_hash "$download" "$expected_sha256"
  mv "$download" "$filename"
)

and_extract()
(
  archive="$1"
  filename="$2"
  expected_sha256="$3"

  trap 'rm -f ".tmp__$filename"' EXIT
  tar tf "$archive" |
    grep -E "(^|/)$filename\$" |
    sed -r 's,^/,,' |
    xargs -d '\n' tar xaf "$archive" -O > ".tmp__$filename"
  check_hash ".tmp__$filename" "$expected_sha256"

  mv ".tmp__$filename" "$filename"
)

uname -o -m 2>&1 | grep -qx 'x86_64 GNU/Linux' || {
  printf "Not on a 64-bit linux system, skipping download step...\n"
  printf "Make sure to install the required binaries manually as described in the README\n"
  exit
} >&2

cd "$(dirname "$0")"
mkdir -p bin
cd bin/

fetch and_rename nvim 1cfbc587ea5598545ac045ee776965a005b1f0c26d5daf5479b859b092697439 \
  "https://github.com/neovim/neovim/releases/download/v0.5.1/nvim.appimage"
fetch and_extract fzf 4b81707da732736266b37006fc5200dda1a05a5ad7216a869e34130160f3b822 \
  "https://github.com/junegunn/fzf/releases/download/0.27.2/fzf-0.27.2-linux_amd64.tar.gz"
fetch and_extract texlab bdff13d2aa34f46cf9291d1697c906ccb4a7de1effd0b37d34b3d8928b5ccbc0 \
  "https://github.com/latex-lsp/texlab/releases/download/v3.2.0/texlab-x86_64-linux.tar.gz"
