#!/usr/bin/env bash

# Below is a list of Required languages for this Neovim configuration
#==============================================================

# Make sure the following languages and file formats are installed.
# This config will still work, however; you'll just encounter many error messages.

# 1. Python3
# 2. Lua
# 3. Java/TypeScript
# 4. HTML/CSS
# 5. Rust
# 6. Go
# 7. C/C++
# 8. Shell
# 9. JSON/YAML
# 10. Markdown
# 11. Docker
# 12. Solidity
# 13. Vue/Svelte
# 14. TOML


check_neovim_version() {
    # Neovim version needs to be 10 or higher
    nvim_version=$(nvim --version)
    if [[ "$nvim_version" < "v0.9.0" ]]; then
        printf "\e[1;31m[-] Neovim version 0.9.0 or higher is required.\e[0m\n"
        printf "\e[1;31m[-] I suggest building from source.\e[0m\n"
        printf "\e[1;31m[-] https://github.com/neovim/neovim/blob/master/BUILD.md.\e[0m\n"
        exit 1
    fi
}

install_prompt() {
        # Acceptable inputs: yes, y, no, n and Enter1
        read -r -p "Ready to install the new Neovim configuration? (yes/no): " confirm
        confirm=${confirm:"yes"}
        # Convert to lowercase for comparison
        confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
        if [[ "$confirm" != "yes" && "$confirm" != "y" ]]; then
            printf "\e[1;31m[-] Exiting installation.\e[0m\n"
            exit 1
        fi
}

# Updating system and installing dependencies
install_deps() {
        printf "\e[1;34m[+] Installing dependencies...\e[0m\n"
        sudo apt update && sudo apt install -y \
             tree-sitter \
             tree-sitter-cli \
             nodjs npm \
             shellcheck \
             ripgrep
}

# Removing your old Neovim config to install the new one
remove_old_config() {
        printf "\e[1;34m[+] Removing old Neovim configuration...\e[0m\n"
        rm -rf ~/.config/nvim; rm -rf ~/.local/share/nvim
}


# Git clone the Neovim configuration repo
install_config() {
        printf "\e[1;34m[+] Git cloning new config & opening Neovim to install plugins...\e[0m\n"
        git clone https://github.com/LinuxUser255/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
        # Open Neovim for the first time and install plugins
        nvim
}


# calling the functions
check_neovim_version
install_prompt
install_deps
remove_old_config
install_config






