This repository contains my personal [Neovim](https://neovim.io/) configuration.

![screenshot](https://user-images.githubusercontent.com/8235638/113520650-d53a5380-9594-11eb-941f-6e8eb4206531.png)

* Font: DejaVu Sans Mono
* Colorscheme: [gruvbox-community](https://github.com/gruvbox-community/gruvbox)

# Dependencies

* [Neovim](https://neovim.io/) 0.7.0 (or higher) with its python3 provider
* Terminal with true 24-bit color support, e.g. GNOME Terminal or iTerm2
* CMake and libpython headers (3.6 or higher) for building
  [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
* [fzf](https://github.com/junegunn/fzf)

# Installation

```sh
git clone --recurse-submodules https://github.com/AlxHnr/nvim ~/.config/nvim
~/.config/nvim/pack/third-party/start/YouCompleteMe/install.py --clangd-completer
```

# License

All the code in this repository, excluding `./pack/third-party/`, is CC0 licensed.
