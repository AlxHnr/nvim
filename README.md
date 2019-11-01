This repository contains my personal [Neovim](https://neovim.io/)
configuration. I use _GNOME Terminal_ with _DejaVu Sans Mono_ (font) and
[palenight.vim](https://github.com/drewtempelmeyer/palenight.vim) as
colorscheme:

![screenshot](https://user-images.githubusercontent.com/8235638/68037890-0b511500-fcc9-11e9-98b1-e31aa40b06f2.png)

# Installation

## Dependencies

* Terminal with true 24-bit color support, e.g. _GNOME Terminal_.
* Development files of libpython3, llvm and libclang with its python3
  bindings. This is required to build
  [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) and
  [ccls](https://github.com/MaskRay/ccls) during plugin installation.
  Python 3.6, libclang 8 and llvm 8 should be sufficient and are available
  in the repositories of Ubuntu 18.04.

## Using `update.sh`

**Note**: This script is only useful if you are using a 64-bit Linux
distribution because it will fetch some binaries. It requires _wget_ and
_pip3_ to be installed.

Clone this repository to `~/.config/` and run `./update.sh` from inside
`~/.config/nvim/`. This will create the `./bin/` directory and populate it
with [Neovim](https://neovim.io/), [fzf](https://github.com/junegunn/fzf)
and [texlab](https://texlab.netlify.com). A python provider will be
installed using _pip3_, followed by the installation of all required vim
plugins.

## Manual installation

**Note**: This is only required if you can't or don't want to use
`update.sh`.

Install a recent version of [Neovim](https://neovim.io/) with its python3
provider. I use Neovim 0.4.2, but older versions _may_ work. Install
[fzf](https://github.com/junegunn/fzf) and
[texlab](https://texlab.netlify.com) and make sure they are accessible from
`$PATH`.

Clone this repository to `~/.config/` and run `nvim +PlugInstall` to
install all required plugins.

## Troubleshooting

If building [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) or
[ccls](https://github.com/MaskRay/ccls) fails due to missing dependencies,
install those and run one of the following commands from inside Neovim to
try again:

```vim
:RebuildYCM
:RebuildCCLS
```

# License

This repository contains a copy of
[vim-plug](https://github.com/junegunn/vim-plug), which is MIT licensed.
Everything else is CC0 licensed.
