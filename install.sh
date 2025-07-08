#!/usr/bin/env bash

# This install script supports 9 Linux Distros & MacOS
# Debian, Ubuntu, Fedora, Red Hat, CentOS Arch, Alpine, OpenSUSE, Void, and MacOS
# It detects your OS, and it's distro / version, then builds Neovim from source.
# Installs the dependencies for the custom Neovim configuration
#
# The Neovim configuration supports the following programming languages & file types
#===================================================================================
#
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
# 15. LaTex -- Soon

install_prompt() {
        # Acceptable inputs: yes, y, no, n and Enter1
        read -r -p "Ready to install the new Neovim configuration? (yes/no) or hit Enter: " confirm
        confirm=${confirm:"yes"}
        confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
        if [[ "$confirm" != "yes" && "$confirm" != "y" ]]; then
            printf "\e[1;31m[-] Exiting installation.\e[0m\n"
            exit 1
        fi
}

# Detect operating system, either macOS or Linux
get_os() {
    case "$(uname -s)" in
        "Darwin")
            # Get macOS version
            darwin_version=$(sw_vers -productVersion)
            case "$darwin_version" in
                16.*) OS="Tahoe" ;;
                15.*) OS="Sequoia" ;;
                14.*) OS="Sonoma" ;;
                13.*) OS="Ventura" ;;
                12.*) OS="Monterey" ;;
                *)    OS="macOS ($darwin_version)" ;;
            esac
        ;;
        "Linux")
            : "Linux"
        ;;
        *BSD|DragonFly|Bitrig)
            : "BSD"
        ;;
        *)
            printf "\e[1;31m[-] Unknown OS detected: '%s', aborting...\e[0m\n" "$(uname -s)" >&2
            exit 1
        ;;
    esac

    # Set the OS variable from the stored value
    OS="$_"
    printf "\e[1;32m[+] Detected OS: %s\e[0m\n" "$OS"
}

# Check for macOS first
detect_distro() {
        # Define an array of supported macOS versions
        local mac_vers=("Tahoe" "Sequoia" "Sonoma" "Ventura" "Monterey")
        local is_macos_version=false

        for ((i=0;i<${#mac_vers[@]};i++)); do
            if [ "$OS" = "${mac_vers[$i]}" ]; then
                is_macos_version=true
                break
            fi
        done

        [ "$OS" ] && is_macos_version=true || is_macos_version=false

        if [ "$is_macos_version" = true ]; then
            DISTRO="$OS"

            # Check if Homebrew is installed
            if command -v brew &> /dev/null; then
                PKG_MANAGER="brew"
            else
                printf "\e[1;33m[!] Homebrew is not installed on your macOS system.\e[0m\n"
                printf "\e[1;34m[?] Would you like to install Homebrew? (yes/no): \e[0m"
                read -r -p "" install_brew
                install_brew=${install_brew:-"no"}
                install_brew=$(echo "$install_brew" | tr '[:upper:]' '[:lower:]')
                if [[ "$install_brew" == "yes" || "$install_brew" == "y" ]]; then
                    printf "\e[1;34m[+] Installing Homebrew...\e[0m\n"
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    PKG_MANAGER="brew"
                else
                    printf "\e[1;31m[-] Homebrew is required for package management on macOS. Exiting.\e[0m\n"
                    exit 1
                fi
            fi
            printf "\e[1;32m[+] Detected macOS: %s (Package Manager: %s)\e[0m\n" "$DISTRO" "$PKG_MANAGER"
            return
        fi

        # Attempt to get distribution info from os-release file
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO="$NAME"
        # Then check specific distribution files in a consistent order
        elif [ -f /etc/lsb-release ]; then
            . /etc/lsb-release
            DISTRO="$DISTRIB_ID"
        elif [ -f /etc/debian_version ]; then
            DISTRO="Debian"
        elif [ -f /etc/ubuntu_version ]; then
            DISTRO="Ubuntu"
        elif [ -f /etc/fedora-release ]; then
            DISTRO="Fedora"
        elif [ -f /etc/redhat-release ]; then
            DISTRO="Red Hat"
        elif [ -f /etc/centos-release ]; then
            DISTRO="CentOS"
        elif [ -f /etc/arch-release ]; then
            DISTRO="Arch"
        elif [ -f /etc/alpine-release ]; then
            DISTRO="Alpine"
        elif [ -f /etc/opensuse-release ]; then
            DISTRO="openSUSE"  # Standardized capitalization
        elif [ -f /etc/void-release ]; then
            DISTRO="Void"
        elif uname -s | grep -q "FreeBSD"; then
            DISTRO="FreeBSD"
        else
            printf "\e[1;31m[-] Unsupported Linux distribution.\e[0m\n"
            exit 1
        fi

        # Determine package manager based on distribution
        case "$DISTRO" in
            "Debian"* | "Ubuntu"*)
                : "apt"
            ;;
            "Fedora"*)
                : "dnf"
            ;;
            "Red Hat"* | "CentOS"*)
                : "dnf"
            ;;
            "Arch"*)
                : "pacman"
            ;;
            "Alpine"*)
                : "apk"
            ;;
            "openSUSE"*)
                : "zypper"
            ;;
            "Void"*)
                : "xbps"
            ;;
            "FreeBSD"*)
                : "pkg"
            ;;
            *)
                printf "\e[1;31m[-] Unsupported Linux distribution.\e[0m\n"
                exit 1
            ;;
        esac

        # Stored value using $_ after the case statement
        PKG_MANAGER="$_"

        printf "\e[1;32m[+] Detected distribution: %s (Package Manager: %s)\e[0m\n" "$DISTRO" "$PKG_MANAGER"
}

full_sys_upgrade() {
    # Based on the detected distribution, perform a full system upgrade using that distribution's package manager
    case "$PKG_MANAGER" in
                "apt")
                    : "sudo apt update && sudo apt upgrade -y"
                ;;
                "dnf")
                    : "sudo dnf update -y"
                ;;
                "pacman")
                    : "sudo pacman -Syu --noconfirm"
                ;;
                "apk")
                    : "sudo apk update && sudo apk upgrade"
                ;;
                "zypper")
                    : "sudo zypper update -y"
                ;;
                "xbps")
                    : "sudo xbps-install -Su -y"
                ;;
                "pkg")
                    : "sudo pkg update && sudo pkg upgrade -y"
                ;;
                "brew")
                    : "brew update && brew upgrade"
                ;;
                *)
                    printf "\e[1;31m[-] Unsupported package manager: %s\e[0m\n" "$PKG_MANAGER"
                    exit 1
                ;;
    esac

    # Execute the command stored in $_
    eval "$_"
}

check_neovim_version() {
        # Check if nvim is installed first
        if ! command -v nvim &> /dev/null; then
            printf "\e[1;31m[-] Neovim is not installed.\e[0m\n"
            printf "\e[1;34m[?] Would you like to install Neovim? (yes/no): \e[0m"
            read -r -p "" install_nvim
            install_nvim=${install_nvim:-"no"}
            install_nvim=$(echo "$install_nvim" | tr '[:upper:]' '[:lower:]')
            if [[ "$install_nvim" == "yes" || "$install_nvim" == "y" ]]; then
                build_neovim
            else
                printf "\e[1;31m[-] Neovim is required for this configuration. Exiting.\e[0m\n"
                exit 1
            fi
            return
        fi

        # Reliably extract version number
        nvim_version=$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+')
        required_version="0.9.0"

        # Compare versions using sort -V (version sort)
        if ! printf "%s\n%s\n" "$required_version" "$nvim_version" | sort -V -C; then
            printf "\e[1;31m[-] Neovim version %s or higher is required. Your version: %s\e[0m\n" "$required_version" "$nvim_version"
            printf "\e[1;34m[?] Would you like to build the latest Neovim from source? (yes/no): \e[0m"
            read -r -p "" build_source
            build_source=${build_source:-"no"}
            build_source=$(echo "$build_source" | tr '[:upper:]' '[:lower:]')
            if [[ "$build_source" == "yes" || "$build_source" == "y" ]]; then
                build_neovim
            else
                printf "\e[1;31m[-] A newer version of Neovim is required. Exiting.\e[0m\n"
                exit 1
            fi
        else
            printf "\e[1;32m[+] Neovim version check passed: %s\e[0m\n" "$nvim_version"
        fi
}

build_neovim() {
        printf "\e[1;34m[+] Building Neovim from source...\e[0m\n"

        # Check if existing Neovim should be removed
        if command -v nvim &> /dev/null; then
            printf "\e[1;34m[?] Remove existing Neovim installation? (yes/no): \e[0m"
            read -r -p "" remove_existing
            remove_existing=${remove_existing:-"no"}
            remove_existing=$(echo "$remove_existing" | tr '[:upper:]' '[:lower:]')
            if [[ "$remove_existing" =~ ^(yes|y)$ ]]; then
                echo "Removing existing Neovim installation..."
                # Complete removal: remove all previous neovim files and directories & purge
                case "$PKG_MANAGER" in
                    "apt")
                        : "sudo apt remove -y neovim && sudo apt purge -y --autoremove neovim"
                    ;;
                    "dnf")
                        : "sudo dnf remove -y neovim && sudo dnf autoremove -y"
                    ;;
                    "pacman")
                        : "sudo pacman -Rns --noconfirm neovim"
                    ;;
                    "apk")
                        : "sudo apk del neovim"
                    ;;
                    "pkg")
                        : "sudo pkg delete -y neovim"
                    ;;
                    "zypper") # openSUSE
                        : "sudo zypper remove -y --clean-deps neovim"
                    ;;
                    "xbps") # Void Linux
                        : "sudo xbps-remove -R -y neovim"
                    ;;
                    "brew") # macOS with Homebrew
                        : "brew remove neovim"
                    ;;
                    *)
                        printf "\e[1;31m[-] Unsupported package manager: %s\e[0m\n" "$PKG_MANAGER"
                        exit 1
                    ;;
                esac

                # Execute the command stored in $_
                eval "$_"
            fi
        fi

        # Install Neovim build prerequisites
        printf "\e[1;34m[+] Installing Neovim build dependencies...\e[0m\n"
        case "$PKG_MANAGER" in
            "apt") # Debian/Ubuntu & debian-based systems
                : "sudo apt install -y ninja-build gettext cmake unzip curl build-essential"
            ;;
            "dnf") # RHEL/Fedora
                : "sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra"
            ;;
            "pacman") # Arch Linux
                : "sudo pacman -S base-devel cmake ninja curl"
            ;;
            "apk") # Alpine Linux
                : "apk add build-base cmake coreutils curl gettext-tiny-dev"
            ;;
            "zypper") # openSUSE
                : "sudo zypper install ninja cmake gcc-c++ gettext-tools curl"
            ;;
            "xbps") # Void Linux
                : "xbps-install base-devel cmake curl git"
            ;;
            "pkg") # FreeBSD
                : "sudo pkg install cmake gmake sha wget gettext curl"
            ;;
            "brew") # macOS with Homebrew
                : "brew install ninja cmake gettext curl"
            ;;
            *)
                printf "\e[1;31m[-] Unsupported package manager: %s\e[0m\n" "$PKG_MANAGER"
                exit 1
            ;;
        esac

        # Execute the command
        eval "$_"

        # Create a temporary directory for building Neovim
        build_dir=$(mktemp -d)
        if ! build_dir=$(mktemp -d); then
            printf "\e[1;31m[-] Failed to create temporary directory for building Neovim.\e[0m\n"
            exit 1
        fi

        # Ensure clean up after build
        trap 'rm -rf "$build_dir"' EXIT

        # Clone Neovim repository
        cd "$build_dir" || {
            printf "\e[1;31m[-] Failed to change directory to %s.\e[0m\n" "$build_dir"
            exit 1
        }

        if ! git clone https://github.com/neovim/neovim.git; then
            printf "\e[1;31m[-] Failed to clone Neovim repository.\e[0m\n"
            exit 1
        fi

        cd neovim || {
            printf "\e[1;31m[-] Failed to change directory to neovim.\e[0m\n"
            exit 1
        }

        # Checkout the stable branch
        if ! git checkout stable; then
            printf "\e[1;31m[-] Failed to checkout stable branch.\e[0m\n"
            exit 1
        fi

        # Build Neovim with parallel jobs
        printf "\e[1;34m[+] Building Neovim (this may take a while)...\e[0m\n"
        if ! make -j"$(nproc)" CMAKE_BUILD_TYPE=RelWithDebInfo; then
            printf "\e[1;31m[-] Failed to build Neovim.\e[0m\n"
            exit 1
        fi

        # Install Neovim
        printf "\e[1;34m[+] Installing Neovim...\e[0m\n"
        if ! sudo make install; then
            printf "\e[1;31m[-] Failed to install Neovim.\e[0m\n"
            exit 1
        fi

        # Create a symbolic link for Neovim if it doesn't exist
        if [ ! -f /usr/bin/nvim ]; then
            sudo ln -sf /usr/local/bin/nvim /usr/bin/nvim
        fi

        printf "\e[1;32m[+] Neovim built and installed successfully.\e[0m\n"

        # Verify the installation
        nvim_version=$(nvim --version | head -n1)
        printf "\e[1;32m[+] Installed: %s\e[0m\n" "$nvim_version"
}


install_nvim_config_deps(){
         printf "\e[1;34m[+] Installing the custom configuration dependencies for %s using %s...\e[0m\n" "$DISTRO" "$PKG_MANAGER"

         case "$PKG_MANAGER" in
             "apt")
                 : "sudo apt update && sudo apt install -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep"
                 ;;
             "dnf")
                 : "sudo dnf update -y && sudo dnf install -y tree-sitter tree-sitter-cli nodejs npm ripgrep"
                 ;;
             "pacman")
                 : "sudo pacman -S --noconfirm tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep"
                 ;;
             "apk")
                 : "sudo apk add --no-cache -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep"
                 ;;
             "pkg")
                 : "sudo pkg install -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep"
                 ;;
             "zypper")
                 : "sudo zypper install -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep"
                 ;;
             "xbps")
                 : "sudo xbps-install -S -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep"
                 ;;
             "brew") # macOS with Homebrew
                 : "brew install tree-sitter node shellcheck ripgrep"
                 ;;
             *)
                 printf "\e[1;31m[-] Unsupported package manager: %s\e[0m\n" "$PKG_MANAGER"
                 exit 1
                 ;;
         esac

         # Execute the command stored in $_
           eval "$_"
}
# Removing your old Neovim config to install the new one
remove_old_config() {
        printf "\e[1;34m[+] Removing old Neovim configuration...\e[0m\n"
        rm -rf ~/.config/nvim; rm -rf ~/.local/share/nvim
        sleep 2
}


# Function to make the nvim directory if it doesn't exist in ~/.config/nvim
# mkdir -p ~/.config/nvim
mk_nvim_dir() {
        mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
        # check that the directory was created
        if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim ]; then
                printf "\e[1;32m[+] Neovim configuration directory created successfully.\e[0m\n"
        else
            # Force a manual creation of the directory if it doesn't exist
            # prompt user to enter mkdir -p ~/.config/nvim
            printf "\e[1;31m[-] Failed to create Neovim configuration directory.\e[0m\n"
            printf "\e[1;31mPlease run the following commands manually:\e[0m\n"
            printf "\e[1;31m    mkdir -p ~/.config/nvim\e[0m\n"
            printf "\e[1;31mThen continue with the custom config installation:\e[0m\n"
            printf "\e[1;31m    git clone https://github.com/LinuxUser255/nvim.git ~/.config/nvim\e[0m\n"
            exit 1
        fi
}

# Git clone the Neovim configuration repo
install_config() {
        printf "\e[1;34m[+] Git cloning new config. Open Neovim to install plugins...\e[0m\n"

        # Create the directory
        mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

        # Clone the repository
        if ! git clone https://github.com/LinuxUser255/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim; then
            printf "\e[1;31m[-] Failed to clone the configuration repository.\e[0m\n"
            printf "\e[1;31m    The directory might not be empty. Try running the script again.\e[0m\n"
            exit 1
        fi

        printf "\e[1;32m[+] Configuration cloned successfully.\e[0m\n"
}

main() {
        install_prompt
        get_os
        detect_distro
        full_sys_upgrade
        check_neovim_version  # This will call build_neovim if needed
        install_nvim_config_deps
        remove_old_config  # Then remove old config (this will recreate the directory)
        install_config
}

main

