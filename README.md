This repository contains my personal [Neovim](https://neovim.io/) configuration. I use _GNOME
Terminal_ with _DejaVu Sans Mono_ (font) and [gruvbox](https://github.com/gruvbox-community/gruvbox)
as colorscheme:

![screenshot](https://user-images.githubusercontent.com/8235638/113520650-d53a5380-9594-11eb-941f-6e8eb4206531.png)

# Installation

## Dependencies

* Terminal with true 24-bit color support, e.g. _GNOME Terminal_.
* Development files of libpython (3.6 or higher). This is required to build
  [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe).
* CMake

## Using `update.sh`

**Note**: This script is only useful if you are using a 64-bit Linux distribution because it will
fetch some binaries. It requires _wget_ and _pip3_ to be installed.

Clone this repository to `~/.config/nvim/` and run `~/.config/nvim/update.sh`. This will download
[Neovim](https://neovim.io/), [fzf](https://github.com/junegunn/fzf) and
[texlab](https://texlab.netlify.com) to `~/.config/nvim/bin/`. A python provider will be installed
using _pip3_, followed by the installation of all required vim plugins.

## Manual installation

**Note**: This is only required if you can't or don't want to use `update.sh`.

Install [Neovim](https://neovim.io/) 0.5.1 (or higher) with its python3 provider. Install
[fzf](https://github.com/junegunn/fzf) and make sure it is accessible from `$PATH`.

Clone this repository to `~/.config/nvim/` and run `nvim +PlugInstall` to install all required
plugins.

# License

This repository contains a copy of [vim-plug](https://github.com/junegunn/vim-plug), which is MIT
licensed. Everything else is CC0 licensed.
