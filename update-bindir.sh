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
fetch and_extract fzf a629e66cdd1c52f901255b8547be7abc2f973ba6efbb4467805f27ae667581d7 \
  "https://github.com/junegunn/fzf/releases/download/0.28.0/fzf-0.28.0-linux_amd64.tar.gz"
