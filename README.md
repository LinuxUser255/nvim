# Neovim Config

![NeoVimConfig-New](https://github.com/user-attachments/assets/32b2e3a4-94b8-4153-845f-856850e89959)






<br>

## [Built with:](https://lua.org)
![lua-logo](https://github.com/LinuxUser255/linux.nvim/assets/46334926/5e54f0b8-ceab-44da-ba32-0b898390c191) ![neovim-logo-github](https://github.com/LinuxUser255/linux.nvim/assets/46334926/4790164b-b06d-4460-a282-33e4469a6ad9)



**https://www.lua.org/**

**https://github.com/neovim**

**[lazy.nvim](https://lazy.folke.io/)**

<br>

## Pre-install Requirements:
  * [ripgrep](https://github.com/BurntSushi/ripgrep#installation) is required for multiple [telescope](https://github.com/nvim-telescope/telescope.nvim#suggested-dependencies) pickers.
  * If you are having issues with Tree-Sitter, then you might not have `node js` installed. The two quick solution to try are:
  * `sudo apt install tree-sitter-cli` if that doesn't work, then you may need to install **Node.js** 
  * `sudo apt install nodejs npm` then Install Tree-sitter CLI globally with npm:
  * `sudo npm install -g tree-sitter-cli`
  * Verify the installation and restart NeoVim
  * `tree-sitter --version`
  * Enababling [Tabnine Auto Completion](https://github.com/codota/tabnine-nvim) will require some additional configuration 

<br>

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

-  Linux and Mac install. Plug n play - Copy past the git clone command below, type neovim, and boom. One and done!
```bash
git clone https://github.com/LinuxUser255/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```



**Neovim's configurations are located under the following paths, depending on your OS:**

| OS    | PATH                                      |
| :---- | :---------------------------------------- |
| Linux | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |

<br>

## Post Install

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

# How to Use

### Remaps & Shortcuts:


***The spacebar is the leader key***

| Command          | Description                            |
|------------------|----------------------------------------|
| `leader pv`      | **Enter Project View**                 |
| `leader ve`      | **Split windows vertically**           |
| `leader he`      | **Split windows horizontally**         |
| `Ctrl l`         | **Jumps to the Right window**          |
| `Ctrl h`         | **Jumps to the Left window**           |
| `Ctrl o`         | **Increase window width by 3 columns** |
| `Ctrl y`         | **Decrease window width by 3 columns** |
| `leader tt`      | **Open Telescope**                     |
| `leader ff`       | **Find file using Telescope**          |


<br>


### Moving lines Up & Down
- Higlight the line, `Shift v`, then while holding down Shift, press `j` to go down
- And `k` to move up.
- This also works with muliple lines selected simultanuiously

| Command              | Description                            |
|----------------------|----------------------------------------|
| `Shift v Shift j`    |  **Moves seclected line down**         |
| `Shift v Shift k`    |  **Moves seclected line up**           |

<br>

### Highlight Replace
| Command       | Description                                                  |
|--------------------------|---------------------------------------------------|
| `Shift s`                |  **Deletes the line and goes into insert mode.**  |                |


<br>








