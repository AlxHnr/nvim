#!/bin/sh -e

# This script updates everything related to this neovim setup.

cd "$(dirname "$0")"

mkdir -p custom/UltiSnips custom/spell

git pull
pip3 install --user neovim --upgrade
./update-bindir.sh

test -e ./bin/nvim && nvim_cmd="./bin/nvim" || nvim_cmd="nvim"

"$nvim_cmd" +PlugUpdate +qall
exec "$nvim_cmd" +PlugDiff +only
