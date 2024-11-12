# Neovim Config


![Neovim-new](https://github.com/LinuxUser255/nvim/assets/46334926/30a2de18-0a82-41fa-8c12-8556830963ec)




<br>

## [Built with:](https://lua.org)
![lua-logo](https://github.com/LinuxUser255/linux.nvim/assets/46334926/5e54f0b8-ceab-44da-ba32-0b898390c191) ![neovim-logo-github](https://github.com/LinuxUser255/linux.nvim/assets/46334926/4790164b-b06d-4460-a282-33e4469a6ad9)



**https://www.lua.org/**

**https://github.com/neovim**

**[lazy.nvim](https://lazy.folke.io/)**


## Pre-install Requirements:
  * [ripgrep](https://github.com/BurntSushi/ripgrep#installation) is required for multiple [telescope](https://github.com/nvim-telescope/telescope.nvim#suggested-dependencies) pickers.
  * If you are having issues with Tree-Sitter, then you might not have `node js` installed. The two quick solution to try are:
  * `sudo apt install tree-sitter-cli` if that doesn't work, then you may need to install **Node.js** 
  * `sudo apt install nodejs npm` then Install Tree-sitter CLI globally with npm:
  * `sudo npm install -g tree-sitter-cli`
  * Verify the installation and restart NeoVim
  * `tree-sitter --version`


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


- The [netrw](https://neovim.io/doc/user/pi_netrw.html) way
```sh
nvim .
```


- Sync [Lazy](https://lazy.folke.io/)
```sh
nvim --headless "+Lazy! sync" +qa
```


<br>
