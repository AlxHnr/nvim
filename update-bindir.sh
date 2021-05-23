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
  tar tf "$archive" |
    grep -E "(^|/)$filename\$" |
    sed -r 's,^/,,' |
    xargs -d '\n' tar xaf "$archive" -O > ".tmp__$filename"
  check_hash ".tmp__$filename" "$sha256"

  mv ".tmp__$filename" "$filename"
)

cd "$(dirname "$0")"
mkdir -p bin
cd bin/

fetch and_rename nvim 1eea3d44f55bab0856d08737c0c50ead7645ae3afd6352a252bc403b9843ec95 \
  "https://github.com/neovim/neovim/releases/download/v0.4.4/nvim.appimage"
fetch and_extract fzf 17f7e5a5a4757c4bf9d01b5d7358bdd45d6a14a2c6f6c2ecb0457023c87d5900 \
  "https://github.com/junegunn/fzf/releases/download/0.27.1/fzf-0.27.1-linux_amd64.tar.gz"
fetch and_extract texlab f75a596121dbbebef14e5b11646c55c3255626b672c6337985e68eade8b3d4af \
  "https://github.com/latex-lsp/texlab/releases/download/v3.0.1/texlab-x86_64-linux.tar.gz"
