#!/bin/sh -e

build_dir="$HOME/.config/nvim/ccls_cmake_build_dir"
trap 'rm -rf "$build_dir"' EXIT

mkdir -p "$build_dir"
cd "$build_dir"
cmake "$HOME/.config/nvim/plugged/ccls"
make "-j$(nproc)"
mkdir -p "$HOME/.config/nvim/bin"
cp ccls "$HOME/.config/nvim/bin"
