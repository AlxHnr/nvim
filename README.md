# My personal neovim setup

This repository contains a minimal and self-contained configuration for
[Neovim](https://neovim.io/). All plugins are bundled as static submodules with no hidden
post-install magic. The config is reloadable at runtime, which allows tinkering without having to
restart neovim. Reloading happens automatically each time `init.lua` is saved to disk. Custom
settings can be added to `./custom/init.lua` and will not be tracked by git.

# Screenshot

![screenshot](https://github.com/AlxHnr/nvim/assets/8235638/d53d9a89-dcdd-4339-b5ff-df1379881068)

* Colorscheme: [kanagawa](https://github.com/rebelot/kanagawa.nvim)
* Font: Hack (patched, see [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts))

# Dependencies

* [Neovim](https://neovim.io/) 0.8.0 (or higher) with its python3 provider
* Any [Nerd Font](https://github.com/ryanoasis/nerd-fonts) of your choice
* [fzf](https://github.com/junegunn/fzf)
* [fd](https://github.com/sharkdp/fd)
* [bat](https://github.com/sharkdp/bat)

# Installation

Clone this repository to `~/.config/nvim`:

```sh
git clone --recurse-submodules https://github.com/AlxHnr/nvim ~/.config/nvim
```

# License

All the code in this repository, excluding `./pack/third-party/`, is CC0 licensed.
