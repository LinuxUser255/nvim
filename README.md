# Neovim Config

![myNeovim](https://github.com/LinuxUser255/linux.nvim/assets/46334926/e2575fcb-495e-40c3-b55f-1a8faa0b990d)

<br>

## [Built with:](https://lua.org)
![lua-logo](https://github.com/LinuxUser255/linux.nvim/assets/46334926/5e54f0b8-ceab-44da-ba32-0b898390c191) ![neovim-logo-github](https://github.com/LinuxUser255/linux.nvim/assets/46334926/4790164b-b06d-4460-a282-33e4469a6ad9)



**https://www.lua.org/**

<br>

**https://github.com/neovim**



## Pre-install Requirements:
  * [ripgrep](https://github.com/BurntSushi/ripgrep#installation) is required for multiple [telescope](https://github.com/nvim-telescope/telescope.nvim#suggested-dependencies) pickers.


## Installation

> **NOTE**
> [Backup](#FAQ) your previous configuration (if any exists)
- Then clear out your current NeoVim configs

```bash
# First delete and remove your current/previous neovim files and dirs.
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
```

<br>

-  Linux and Mac install
```bash
git clone https://github.com/LinuxUser255/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```



**Neovim's configurations are located under the following paths, depending on your OS:**

| OS    | PATH                                      |
| :---- | :---------------------------------------- |
| Linux | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |


### Post Install

**Open Neovim**

- The regular way
```sh
nvim
```


- The `netrw` way
```sh
nvim .
```


- Sync Lazy
```sh
nvim --headless "+Lazy! sync" +qa
```


<br>
