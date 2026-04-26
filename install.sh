#!/usr/bin/env bash
# =============================================================================
# NAME
#   install.sh — Build Neovim from source with full language support
#
# DESCRIPTION
#   Detects the host OS and distribution, installs all required build
#   dependencies, compiles Neovim from source, then sets up a custom
#   configuration with LSP and treesitter support.
#
#   Supported platforms:
#     Linux   — Debian, Ubuntu, Kali, Fedora, Red Hat, CentOS, Arch,
#               Alpine, OpenSUSE, Void
#     macOS   — Monterey, Ventura, Sonoma, Sequoia, Tahoe
#
# LANGUAGE SUPPORT
#   Python3 · Lua · Java · TypeScript · HTML · CSS · Rust · Go
#   C · C++ · Shell · JSON · YAML · Markdown · Docker · Solidity
#   Vue · Svelte · TOML · LaTeX
#
# DEPENDENCIES
#   Required:  git, curl, make, cmake, gcc (or clang)
#   Optional:  cargo (Rust LSP), go (Go LSP), java (Java LSP)
#
# USAGE
#   ./install.sh
#
# AUTHOR
#   Your Name <you@example.com>
#
# VERSION
#   1.0.0 — 2025-04-25
# =============================================================================
set -euo pipefail
IFS=$'\n\t'

# Disable unicode — pure ASCII processing
LC_ALL=C
LANG=C

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Parallel helper function
run_parallel_tasks() {
        local -n _results="$1"
        shift

        local joblist=()
        local MAX_JOBS=$(nproc)

        for task in "$@"; do
            $task &
            joblist+=($!)

            if (( ${#joblist[@]} >= MAX_JOBS )); then
                    wait "${joblist[0]}" 2>/dev/null || true
                    joblist=("${joblist[@]:1}")
            fi

        done

        wait
        _results["done"]=1
}


# --- State variables (all initialized to satisfy set -u) ---------------------
DIR="${1:-.}"
TERM="${2:-error}"
DEBUG="${DEBUG:-0}"
OS=""
DISTRO=""
PKG_MANAGER=""

# --- Helpers -----------------------------------------------------------------
debug() { [[ "$DEBUG" == 1 ]] && printf '%b[DEBUG]%b %s\n' "${CYAN}" "${NC}" "$*"; }

print_banner() {
        debug "print_banner"
        printf '%b\n' "${CYAN}╔════════════════════════════════════════════════╗${NC}"
        printf '%b\n' "${CYAN}║        Neovim Config: ${DIR}                   ║${NC}"
        printf '%b\n' "${CYAN}║        Term:          ${TERM}                  ║${NC}"
        printf '%b\n' "${CYAN}╚════════════════════════════════════════════════╝${NC}"
        echo ""
}

install_prompt() {
        debug "install_prompt"
        read -r -p "Ready to install the new Neovim configuration? (yes/no) or hit Enter: " confirm
        confirm=${confirm:-"yes"}
        confirm="${confirm,,}"  # convert to lowercase for case-insensitive comparison
        if ! [[ "$confirm" =~ ^(yes|y)$ ]]; then
                printf '%b[-]%b Exiting installation.\n' "${RED}" "${NC}"
                exit 1
        fi
}

get_os() {
        debug "get_os"
        local os_type="$OSTYPE"
        case "$os_type" in
                darwin*)
                        local darwin_version
                        darwin_version=$(sw_vers -productVersion)
                        case "$darwin_version" in
                                16.*) OS="Tahoe"    ;;
                                15.*) OS="Sequoia"  ;;
                                14.*) OS="Sonoma"   ;;
                                13.*) OS="Ventura"  ;;
                                12.*) OS="Monterey" ;;
                                *)    OS="macOS"    ;;
                        esac
                ;;
                linux*)
                        OS="Linux"
                ;;
                freebsd*|netbsd*|openbsd*|dragonfly*|bitrig*)
                        OS="BSD"
                ;;
                *)
                        printf '%b[-]%b Unknown OS detected: %s, aborting...\n' "${RED}" "${NC}" "$OSTYPE"
                        exit 1
                ;;
        esac

        printf '%b[+]%b Detected OS: %s\n' "${GREEN}" "${NC}" "$OS"
}

detect_distro() {
        debug "detect_distro"
        local -n _distro=$1

        if [[ "$OS" == "macOS" || "$OS" == "Tahoe" || "$OS" == "Sequoia" || "$OS" == "Sonoma" || "$OS" == "Ventura" || "$OS" == "Monterey" ]]; then
                DISTRO="$OS"

                if command -v brew &> /dev/null; then
                        PKG_MANAGER="brew"
                else
                        printf '%b[!]%b Homebrew is not installed on your macOS system.\n' "${YELLOW}" "${NC}"
                        printf '%b[?]%b Would you like to install Homebrew? (yes/no): ' "${CYAN}" "${NC}"
                        read -r -p "" install_brew
                        install_brew=${install_brew:-"no"}
                        install_brew="${install_brew,,}"
                        if [[ "$install_brew" == "yes" || "$install_brew" == "y" ]]; then
                                printf '%b[+]%b Installing Homebrew...\n' "${CYAN}" "${NC}"
                                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                                PKG_MANAGER="brew"
                        else
                                printf '%b[-]%b Homebrew is required for package management on macOS. Exiting.\n' "${RED}" "${NC}"
                                exit 1
                        fi
                fi
                printf '%b[+]%b Detected macOS: %s (Package Manager: %s)\n' "${GREEN}" "${NC}" "$DISTRO" "$PKG_MANAGER"
                return 0
        fi

        # Linux distro detection
        if [[ -f /etc/os-release ]]; then
                . /etc/os-release
                DISTRO="${NAME:-Unknown}"
        elif [[ -f /etc/lsb-release ]]; then
                . /etc/lsb-release
                DISTRO="${DISTRIB_ID:-Unknown}"
        elif [[ -f /etc/debian_version ]]; then
                DISTRO="Debian"
        elif [[ -f /etc/kali-release ]]; then
                DISTRO="Kali Linux"
        elif [[ -f /etc/ubuntu_version ]]; then
                DISTRO="Ubuntu"
        elif [[ -f /etc/fedora-release ]]; then
                DISTRO="Fedora"
        elif [[ -f /etc/redhat-release ]]; then
                DISTRO="Red Hat"
        elif [[ -f /etc/centos-release ]]; then
                DISTRO="CentOS"
        elif [[ -f /etc/arch-release ]]; then
                DISTRO="Arch"
        elif [[ -f /etc/alpine-release ]]; then
                DISTRO="Alpine"
        elif [[ -f /etc/opensuse-release ]]; then
                DISTRO="openSUSE"
        elif [[ -f /etc/void-release ]]; then
                DISTRO="Void"
        else
                printf '%b[-]%b Unsupported Linux distribution.\n' "${RED}" "${NC}"
                exit 1
        fi

        case "$DISTRO" in
                "Debian"* | "Ubuntu"* | "Kali"*)
                        PKG_MANAGER="apt"
                ;;
                "Fedora"*)
                        PKG_MANAGER="dnf"
                ;;
                "Red Hat"* | "CentOS"*)
                        PKG_MANAGER="dnf"
                ;;
                "Arch"*)
                        PKG_MANAGER="pacman"
                ;;
                "Alpine"*)
                        PKG_MANAGER="apk"
                ;;
                "openSUSE"*)
                        PKG_MANAGER="zypper"
                ;;
                "Void"*)
                        PKG_MANAGER="xbps"
                ;;
                *)
                        printf '%b[-]%b Unsupported distribution: %s\n' "${RED}" "${NC}" "$DISTRO"
                        exit 1
                ;;
        esac

        printf '%b[+]%b Detected distribution: %s (Package Manager: %s)\n' "${GREEN}" "${NC}" "$DISTRO" "$PKG_MANAGER"
}

#NOTE: Can the function above be refactored for Parallel distro detection?
# Like this???
#check_file() {
#        local -n _found="$1"
#        local file="$2"
#        local distro_name="$3"
#
#        if [[ -f "$file" ]]; then
#                _found["$distro_name"]=1
#        fi
#}

full_sys_upgrade() {
        debug "full_sys_upgrade"
        local cmd=""
        case "$PKG_MANAGER" in
                "apt")      cmd="sudo apt update && sudo apt upgrade -y" ;;
                "dnf")      cmd="sudo dnf update -y" ;;
                "pacman")   cmd="sudo pacman -Syu --noconfirm" ;;
                "apk")      cmd="sudo apk update && sudo apk upgrade" ;;
                "zypper")   cmd="sudo zypper update -y" ;;
                "xbps")     cmd="sudo xbps-install -Su -y" ;;
                "pkg")      cmd="sudo pkg update && sudo pkg upgrade -y" ;;
                "brew")     cmd="brew update && brew upgrade" ;;
                *)          printf '%b[-]%b Unsupported package manager: %s\n' "${RED}" "${NC}" "$PKG_MANAGER"; exit 1 ;;
        esac
        eval "$cmd"
}

check_neovim_version() {
        debug "check_neovim_version"
        local -n _ver="$1"

        if ! command -v nvim &> /dev/null; then
                printf '%b[-]%b Neovim is not installed.\n' "${RED}" "${NC}"
                printf '%b[?]%b Would you like to install Neovim? (yes/no): ' "${CYAN}" "${NC}"
                read -r -p "" install_nvim
                install_nvim=${install_nvim:-"no"}
                install_nvim="${install_nvim,,}"
                if [[ "$install_nvim" == "yes" || "$install_nvim" == "y" ]]; then
                        build_neovim
                else
                        printf '%b[-]%b Neovim is required for this configuration. Exiting.\n' "${RED}" "${NC}"
                        exit 1
                fi
                return 0
        fi

        # Extract version (single fork + pure Bash)
        local raw
        raw=$(nvim --version | head -n1)
        raw=${raw#*v}
        _ver=${raw%%-*}

        local required_version="0.9.0"

        # Version comparison using sort -V
        if printf "%s\n%s\n" "$required_version" "$_ver" | sort -V -C; then
                printf '%b[+]%b Neovim version check passed: %s\n' "${GREEN}" "${NC}" "$_ver"
        else
                printf '%b[-]%b Neovim version %s or higher is required. Your version: %s\n' "${RED}" "${NC}" "$required_version" "$_ver"
                printf '%b[?]%b Would you like to build the latest Neovim from source? (yes/no): ' "${CYAN}" "${NC}"
                read -r -p "" build_source
                build_source=${build_source:-"no"}
                build_source="${build_source,,}"
                if [[ "$build_source" == "yes" || "$build_source" == "y" ]]; then
                        build_neovim
                else
                        printf '%b[-]%b A newer version of Neovim is required. Exiting.\n' "${RED}" "${NC}"
                        exit 1
                fi
        fi
}

build_neovim() {
        debug "build_neovim"
        printf '%b[+]%b Building Neovim from source...\n' "${CYAN}" "${NC}"

        if command -v nvim &> /dev/null; then
                printf '%b[?]%b Remove existing Neovim installation? (yes/no): ' "${CYAN}" "${NC}"
                read -r -p "" remove_existing
                remove_existing=${remove_existing:-"no"}
                remove_existing="${remove_existing,,}"
                if [[ "$remove_existing" =~ ^(yes|y)$ ]]; then
                        printf '%b[+]%b Removing existing Neovim installation...\n' "${CYAN}" "${NC}"
                        local cmd=""
                        case "$PKG_MANAGER" in
                                "apt")    cmd="sudo apt remove -y neovim && sudo apt purge -y --autoremove neovim" ;;
                                "dnf")    cmd="sudo dnf remove -y neovim && sudo dnf autoremove -y" ;;
                                "pacman") cmd="sudo pacman -Rns --noconfirm neovim" ;;
                                "apk")    cmd="sudo apk del neovim" ;;
                                "pkg")    cmd="sudo pkg delete -y neovim" ;;
                                "zypper") cmd="sudo zypper remove -y --clean-deps neovim" ;;
                                "xbps")   cmd="sudo xbps-remove -R -y neovim" ;;
                                "brew")   cmd="brew remove neovim" ;;
                                *)        printf '%b[-]%b Unsupported package manager: %s\n' "${RED}" "${NC}" "$PKG_MANAGER"; exit 1 ;;
                        esac
                        eval "$cmd"
                fi
        fi

        printf '%b[+]%b Installing Neovim build dependencies...\n' "${CYAN}" "${NC}"
        local cmd=""
        case "$PKG_MANAGER" in
                "apt")    cmd="sudo apt install -y ninja-build gettext cmake unzip curl build-essential" ;;
                "dnf")    cmd="sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra" ;;
                "pacman") cmd="sudo pacman -S base-devel cmake ninja curl" ;;
                "apk")    cmd="apk add build-base cmake coreutils curl gettext-tiny-dev" ;;
                "zypper") cmd="sudo zypper install ninja cmake gcc-c++ gettext-tools curl" ;;
                "xbps")   cmd="xbps-install base-devel cmake curl git" ;;
                "pkg")    cmd="sudo pkg install cmake gmake sha wget gettext curl" ;;
                "brew")   cmd="brew install ninja cmake gettext curl" ;;
                *)        printf '%b[-]%b Unsupported package manager: %s\n' "${RED}" "${NC}" "$PKG_MANAGER"; exit 1 ;;
        esac
        eval "$cmd"

        local build_dir="/tmp/nvim-build-$$-$RANDOM"
        if ! mkdir -p "$build_dir"; then
                printf '%b[-]%b Failed to create temporary build directory.\n' "${RED}" "${NC}"
                exit 1
        fi
        trap 'rm -rf "$build_dir"' EXIT

        cd "$build_dir" || { printf '%b[-]%b Failed to cd to %s\n' "${RED}" "${NC}" "$build_dir"; exit 1; }

        if ! git clone https://github.com/neovim/neovim.git; then
                printf '%b[-]%b Failed to clone Neovim repository.\n' "${RED}" "${NC}"
                exit 1
        fi

        cd neovim || { printf '%b[-]%b Failed to cd to neovim\n' "${RED}" "${NC}"; exit 1; }

        if ! git checkout stable; then
                printf '%b[-]%b Failed to checkout stable branch.\n' "${RED}" "${NC}"
                exit 1
        fi

        printf '%b[+]%b Building Neovim (this may take a while)...\n' "${CYAN}" "${NC}"
        if ! make -j"$(nproc)" CMAKE_BUILD_TYPE=RelWithDebInfo; then
                printf '%b[-]%b Failed to build Neovim.\n' "${RED}" "${NC}"
                exit 1
        fi

        printf '%b[+]%b Installing Neovim...\n' "${CYAN}" "${NC}"
        if ! sudo make install; then
                printf '%b[-]%b Failed to install Neovim.\n' "${RED}" "${NC}"
                exit 1
        fi

        if [[ ! -f /usr/bin/nvim ]]; then
                sudo ln -sf /usr/local/bin/nvim /usr/bin/nvim
        fi

        printf '%b[+]%b Neovim built and installed successfully.\n' "${GREEN}" "${NC}"

        local installed_version
        installed_version=$(nvim --version | head -n1)
        printf '%b[+]%b Installed: %s\n' "${GREEN}" "${NC}" "$installed_version"
}

install_nvim_config_deps() {
        debug "install_nvim_config_deps"
        printf '%b[+]%b Installing custom configuration dependencies for %s using %s...\n' "${CYAN}" "${NC}" "$DISTRO" "$PKG_MANAGER"

        local cmd=""
        case "$PKG_MANAGER" in
                "apt")    cmd="sudo apt update && sudo apt install -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
                "dnf")    cmd="sudo dnf update -y && sudo dnf install -y tree-sitter tree-sitter-cli nodejs npm ripgrep" ;;
                "pacman") cmd="sudo pacman -S --noconfirm tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
                "apk")    cmd="sudo apk add --no-cache tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
                "pkg")    cmd="sudo pkg install -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
                "zypper") cmd="sudo zypper install -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
                "xbps")   cmd="sudo xbps-install -S -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
                "brew")   cmd="brew install tree-sitter node shellcheck ripgrep" ;;
                *)        printf '%b[-]%b Unsupported package manager: %s\n' "${RED}" "${NC}" "$PKG_MANAGER"; exit 1 ;;
        esac
        eval "$cmd"
}

remove_old_config() {
        debug "remove_old_config"
        printf '%b[+]%b Removing old Neovim configuration...\n' "${CYAN}" "${NC}"
        rm -rf ~/.config/nvim ~/.local/share/nvim
        sleep 2
}

mk_nvim_dir() {
        debug "mk_nvim_dir"
        mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
        if [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim ]]; then
                printf '%b[+]%b Neovim configuration directory created successfully.\n' "${GREEN}" "${NC}"
        else
                printf '%b[-]%b Failed to create Neovim configuration directory.\n' "${RED}" "${NC}"
                printf '%b    Please run manually: mkdir -p ~/.config/nvim\n' "${RED}"
                exit 1
        fi
}

install_config() {
        debug "install_config"
        printf '%b[+]%b Git cloning new config. Open Neovim to install plugins...\n' "${CYAN}" "${NC}"

        if ! git clone https://github.com/LinuxUser255/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim; then
                printf '%b[-]%b Failed to clone the configuration repository.\n' "${RED}" "${NC}"
                printf '%b    The directory might not be empty. Try running the script again.\n' "${RED}"
                exit 1
        fi

        printf '%b[+]%b Configuration cloned successfully.\n' "${GREEN}" "${NC}"
}

main() {
        debug "main"
        print_banner
        install_prompt
        get_os
        detect_distro DISTRO
        declare -A parallel_results
        run_parallel_tasks parallel_results full_sys_upgrade install_nvim_config_deps
        full_sys_upgrade
        check_neovim_version nvim_version
        install_nvim_config_deps
        remove_old_config
        mk_nvim_dir
        install_config
}

main "$@"
