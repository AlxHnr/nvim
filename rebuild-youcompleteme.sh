#!/bin/sh -e

ycm_rebuild_dir="$HOME/.config/nvim/youcompleteme_cmake_build_dir"
trap 'rm -rf "$ycm_rebuild_dir"' EXIT

mkdir -p "$ycm_rebuild_dir"
cd "$ycm_rebuild_dir"
cmake -DUSE_SYSTEM_LIBCLANG=ON -DUSE_PYTHON2=OFF \
  "$HOME/.config/nvim/plugged/YouCompleteMe/third_party/ycmd/cpp/"
make "-j$(nproc)"
