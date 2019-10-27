#!/bin/sh -e

# This script updates everything related to this neovim setup.

cd "$(dirname "$0")"

git pull
pip3 install --user neovim --upgrade
./update-bindir.sh

./bin/nvim +PlugUpdate +qall

echo
echo "SUCCESS!"
