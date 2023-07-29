# My personal neovim setup

This repository contains a minimal and self-contained configuration for
[Neovim](https://neovim.io/). All plugins are bundled as static submodules with no hidden
post-install magic. The config is reloadable at runtime, which allows tinkering without having to
restart neovim. Reloading happens automatically each time `init.lua` is saved to disk. Custom
settings can be added to `./custom/init.lua` and will not be tracked by git.

# Screenshot

![screenshot](https://user-images.githubusercontent.com/8235638/167307113-efc7d7a5-ea4d-4c53-a0d9-84c2a6d2d422.png)

* Colorscheme: [nightfox](https://github.com/EdenEast/nightfox.nvim)
* Font: DejaVu Sans Mono (patched, see [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts))

# Dependencies

* [Neovim](https://neovim.io/) 0.8.0 (or higher) with its python3 provider
* Any [Nerd Font](https://github.com/ryanoasis/nerd-fonts) of your choice

# Installation

Clone this repository to `~/.config/nvim`:

```sh
git clone --recurse-submodules https://github.com/AlxHnr/nvim ~/.config/nvim
```

# License

All the code in this repository, excluding `./pack/third-party/`, is CC0 licensed.
