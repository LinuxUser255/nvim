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
    # Extract version number
    nvim_version=$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?')

    # Neovim version needs to be 10 or higher
    required_version="0.9.0"

    # Compare versions using sort -V
    if ! printf "%s\n%s" "$required_version" "$nvim_version" | sort -VC; then
        printf "\e[1;31m[-] Neovim version %s or higher is required.\e[0m\n" "$required_version"
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

# Updating system and installing dependencies Debian based distros
install_deps_debian() {
        printf "\e[1;34m[+] Installing dependencies...\e[0m\n"
        sudo apt update && sudo apt install -y \
             tree-sitter \
             tree-sitter-cli \
             nodejs npm \
             shellcheck \
             ripgrep
}

# Update system and install dependencies for Arch based distros
install_deps_arch() {
    printf "\e[1;34m[+] Installing dependencies...\e[0m\n"
    sudo pacman -Syu --needed --noconfirm \
        tree-sitter \
        tree-sitter-cli \
        nodejs \
        npm \
        shellcheck \
        ripgrep
}

# Check current OS and then install dependencies using the appropriate package manager
install_deps() {
    # Detect OS
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            arch|archcraft|endeavouros|manjaro)
                install_deps_arch
                ;;
            debian|ubuntu|linuxmint|pop)
                install_deps_debian
                ;;
            *)
                echo "Unsupported OS: $ID"
                exit 1
                ;;
        esac
    else
        echo "Cannot detect OS. /etc/os-release not found."
        exit 1
    fi
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

