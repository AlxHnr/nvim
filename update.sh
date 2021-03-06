#!/bin/sh -e

# This script updates everything related to this neovim setup.

cd "$(dirname "$0")"

mkdir -p custom/UltiSnips custom/spell

git pull
pip3 install --user neovim --upgrade
./update-bindir.sh

./bin/nvim +PlugUpdate +qall
exec ./bin/nvim +PlugDiff +only
