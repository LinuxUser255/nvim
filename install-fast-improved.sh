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
#   1.1.0 — 2026-04-26
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

# --- State variables (all initialized to satisfy set -u) ---------------------

# BUG 1 FIX — TERM collision
# ORIGINAL: TERM="${2:-error}"
# $TERM is a reserved shell variable — it holds the terminal type (xterm-256color,
# screen-256color, etc.). Overwriting it breaks any command that queries terminal
# capabilities downstream (tput, less, man, ncurses apps).
# FIX: rename to SEARCH_TERM to avoid clobbering the shell's own variable.
DIR="${1:-.}"
SEARCH_TERM="${2:-error}"
DEBUG="${DEBUG:-0}"
OS=""
DISTRO=""
PKG_MANAGER=""
BUILD_DIR=""

# BUG 2 FIX — Cache nproc once at startup
# ORIGINAL: $(nproc) called twice — once in run_parallel_tasks, once in build_neovim
# nproc is an external binary (unavoidable fork — no bash builtin for CPU count).
# But there is no reason to fork it more than once. Cache the result here and
# reuse the variable throughout. CPU count does not change during a script run.
NPROC=$(nproc)
readonly NPROC

# --- Helpers -----------------------------------------------------------------

# BUG 3 FIX — §2 &&-trap: missing return 0
# ORIGINAL: debug() { [[ "$DEBUG" == 1 ]] && printf '...' "$*"; }
# Under set -euo pipefail, when DEBUG=0 the [[ ]] test evaluates false (exit 1).
# The && short-circuits, the function exits with code 1.
# set -e sees a non-zero exit from a function call and silently kills the script.
# Every call to debug() in the script would terminate it when DEBUG is off.
# FIX: explicit return 0 — load-bearing, not cosmetic. Tells set -e the function
# succeeded regardless of whether the [[ ]] test was true or false.
debug() {
        [[ "$DEBUG" == 1 ]] && printf '%b[DEBUG]%b %s\n' "${CYAN}" "${NC}" "$*"
        return 0   # §2 &&-trap guard
}

print_banner() {
        debug "print_banner"
        printf '%b\n' "${CYAN}╔════════════════════════════════════════════════╗${NC}"
        printf '%b\n' "${CYAN}║        Neovim Config: ${DIR}                   ║${NC}"
        printf '%b\n' "${CYAN}║        Term:          ${SEARCH_TERM}           ║${NC}"
        printf '%b\n' "${CYAN}╚════════════════════════════════════════════════╝${NC}"
        printf '\n'
        return 0
}

install_prompt() {
        debug "install_prompt"
        read -r -p "Ready to install the new Neovim configuration? (yes/no) or hit Enter: " confirm
        confirm="${confirm:-yes}"
        confirm="${confirm,,}"
        if ! [[ "$confirm" =~ ^(yes|y)$ ]]; then
            printf '%b[-]%b Exiting installation.\n' "${RED}" "${NC}"
            exit 1
        fi
        return 0
}

get_os() {
        debug "get_os"
        case "$OSTYPE" in
            darwin*)
                local darwin_version
                darwin_version=$(sw_vers -productVersion)   # unavoidable external call
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
        return 0
}

detect_distro() {
        debug "detect_distro"

        # BUG 4 FIX — dead nameref parameter
        # ORIGINAL: local -n _distro=$1  (declared but never assigned — $1 was "DISTRO")
        # The nameref _distro was set up to be an alias for the caller's variable, but
        # the function body set DISTRO directly as a global and never wrote to _distro.
        # The nameref did nothing — it was dead code that only added confusion.
        # FIX: remove the unused nameref entirely. The function sets DISTRO and
        # PKG_MANAGER directly as globals, which is its actual behavior. Call site
        # in main() updated accordingly: detect_distro  (no argument needed).
        #
        # NOTE on the commented parallel distro detection idea (lines 224-234):
        # DO NOT parallelize distro detection. Every check is [[ -f /etc/... ]] —
        # a bash builtin test, no fork, completes in microseconds. Spawning background
        # jobs has a fork+exec cost of ~1-5ms each. The overhead of parallelism would
        # be 100-1000x more expensive than the sequential builtin checks it replaces.
        # Parallelism pays off for I/O-bound or CPU-bound work — not for [[ -f ]] tests.

        if [[ "$OS" == "macOS"    || "$OS" == "Tahoe"    || "$OS" == "Sequoia" ||
              "$OS" == "Sonoma"   || "$OS" == "Ventura"  || "$OS" == "Monterey" ]]; then
            DISTRO="$OS"

            if command -v brew &>/dev/null; then
                PKG_MANAGER="brew"
            else
                printf '%b[!]%b Homebrew is not installed on your macOS system.\n' "${YELLOW}" "${NC}"
                printf '%b[?]%b Would you like to install Homebrew? (yes/no): ' "${CYAN}" "${NC}"
                read -r -p "" install_brew
                install_brew="${install_brew:-no}"
                install_brew="${install_brew,,}"
                if [[ "$install_brew" == "yes" || "$install_brew" == "y" ]]; then
                    printf '%b[+]%b Installing Homebrew...\n' "${CYAN}" "${NC}"
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    PKG_MANAGER="brew"
                else
                    printf '%b[-]%b Homebrew is required on macOS. Exiting.\n' "${RED}" "${NC}"
                    exit 1
                fi
            fi
            printf '%b[+]%b Detected macOS: %s (Package Manager: %s)\n' "${GREEN}" "${NC}" "$DISTRO" "$PKG_MANAGER"
            return 0
        fi

        # Linux distro detection — all [[ -f ]] tests are bash builtins, zero forks
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            DISTRO="${NAME:-Unknown}"
        elif [[ -f /etc/lsb-release ]]; then
            . /etc/lsb-release
            DISTRO="${DISTRIB_ID:-Unknown}"
        elif [[ -f /etc/debian_version ]];  then DISTRO="Debian"
        elif [[ -f /etc/kali-release ]];    then DISTRO="Kali Linux"
        elif [[ -f /etc/ubuntu_version ]];  then DISTRO="Ubuntu"
        elif [[ -f /etc/fedora-release ]];  then DISTRO="Fedora"
        elif [[ -f /etc/redhat-release ]];  then DISTRO="Red Hat"
        elif [[ -f /etc/centos-release ]];  then DISTRO="CentOS"
        elif [[ -f /etc/arch-release ]];    then DISTRO="Arch"
        elif [[ -f /etc/alpine-release ]];  then DISTRO="Alpine"
        elif [[ -f /etc/opensuse-release ]];then DISTRO="openSUSE"
        elif [[ -f /etc/void-release ]];    then DISTRO="Void"
        else
            printf '%b[-]%b Unsupported Linux distribution.\n' "${RED}" "${NC}"
            exit 1
        fi

        case "$DISTRO" in
            "Debian"*|"Ubuntu"*|"Kali"*)   PKG_MANAGER="apt"    ;;
            "Fedora"*)                       PKG_MANAGER="dnf"    ;;
            "Red Hat"*|"CentOS"*)           PKG_MANAGER="dnf"    ;;
            "Arch"*)                         PKG_MANAGER="pacman" ;;
            "Alpine"*)                       PKG_MANAGER="apk"    ;;
            "openSUSE"*)                     PKG_MANAGER="zypper" ;;
            "Void"*)                         PKG_MANAGER="xbps"   ;;
            *)
                printf '%b[-]%b Unsupported distribution: %s\n' "${RED}" "${NC}" "$DISTRO"
                exit 1
            ;;
        esac

        printf '%b[+]%b Detected distribution: %s (Package Manager: %s)\n' "${GREEN}" "${NC}" "$DISTRO" "$PKG_MANAGER"
        return 0
}

full_sys_upgrade() {
        debug "full_sys_upgrade"
        local cmd=""
        case "$PKG_MANAGER" in
            "apt")    cmd="sudo apt update && sudo apt full-upgrade -y" ;;
            "dnf")    cmd="sudo dnf update -y"                      ;;
            "pacman") cmd="sudo pacman -Syu --noconfirm"            ;;
            "apk")    cmd="sudo apk update && sudo apk upgrade"     ;;
            "zypper") cmd="sudo zypper update -y"                   ;;
            "xbps")   cmd="sudo xbps-install -Su -y"               ;;
            "pkg")    cmd="sudo pkg update && sudo pkg upgrade -y"  ;;
            "brew")   cmd="brew update && brew upgrade"             ;;
            *)
                printf '%b[-]%b Unsupported package manager: %s\n' "${RED}" "${NC}" "$PKG_MANAGER"
                exit 1
            ;;
        esac
        eval "$cmd"
        return 0
}

check_neovim_version() {
        debug "check_neovim_version"

        # BUG 5 FIX — nameref _ver pointed at undeclared variable
        # ORIGINAL: local -n _ver="$1"  called as: check_neovim_version nvim_version
        # nvim_version was never declared in main() before this call. More importantly,
        # the _ver nameref result was never actually used after the call returned —
        # it was dead output. The function's real job is to decide whether to build,
        # not to return a value the caller uses.
        # FIX: remove the nameref entirely. Use a plain local variable for the version
        # string. The function prints the result and calls build_neovim() if needed —
        # that is its complete contract with the caller.

        if ! command -v nvim &>/dev/null; then
            printf '%b[-]%b Neovim is not installed.\n' "${RED}" "${NC}"
            printf '%b[?]%b Would you like to install Neovim? (yes/no): ' "${CYAN}" "${NC}"
            read -r -p "" install_nvim
            install_nvim="${install_nvim:-no}"
            install_nvim="${install_nvim,,}"
            if [[ "$install_nvim" == "yes" || "$install_nvim" == "y" ]]; then
                build_neovim
            else
                printf '%b[-]%b Neovim is required. Exiting.\n' "${RED}" "${NC}"
                exit 1
            fi
            return 0
        fi

        # BUG 6 FIX — head -n1 fork replaced with read + process substitution
        # ORIGINAL: raw=$(nvim --version | head -n1)
        # The pipe sends nvim's stdout through head -n1 — two forks (nvim + head).
        # head -n1 just discards every line after the first, which read -r already
        # does naturally: it stops after consuming exactly one line from the fd.
        # < <(nvim --version) runs nvim via process substitution (unavoidable fork
        # for the binary itself), but eliminates the head fork entirely.
        local ver
        IFS= read -r ver < <(nvim --version)   # one fork (nvim), head eliminated
        ver="${ver#*v}"                          # "NVIM v0.12.2-dev" → "0.12.2-dev"
        # REMOVED: ver="${ver%%-*}" — stripping -dev would make 0.12.2-dev == 0.12.2,
        # causing any 0.12.2 release to satisfy a requirement for the dev build


        local required_version="0.12.2-dev"

        # sort -V order: 0.12.1 < 0.12.2-dev < 0.12.2
        # So: 0.12.1 fails (correct), 0.12.2-dev passes (correct), 0.12.2 passes (correct)
        if printf '%s\n%s\n' "$required_version" "$ver" | sort -V -C; then
            printf '%b[+]%b Neovim version check passed: %s\n' "${GREEN}" "${NC}" "$ver"
        else
            printf '%b[-]%b Required: %s — Found: %s\n' "${RED}" "${NC}" "$required_version" "$ver"
            printf '%b[+]%b Building required dev version from source...\n' "${CYAN}" "${NC}"
            # No prompt — if the version fails for a dev build requirement there is
            # no alternative. The script's entire purpose requires this specific build.
            build_neovim
        fi
        return 0
}


# build_neovim
check_neovim_version() {
        debug "check_neovim_version"

        if ! command -v nvim &>/dev/null; then
            printf '%b[-]%b Neovim is not installed.\n' "${RED}" "${NC}"
            printf '%b[+]%b Building required dev version from source...\n' "${CYAN}" "${NC}"
            build_neovim
            return 0
        fi

        # Read full version string — do NOT strip -dev suffix
        # Required version IS a dev build so the suffix is meaningful for comparison
        local ver
        IFS= read -r ver < <(nvim --version)   # one fork, no head fork
        ver="${ver#*v}"                          # "NVIM v0.12.2-dev" → "0.12.2-dev"
        # REMOVED: ver="${ver%%-*}" — stripping -dev would make 0.12.2-dev == 0.12.2,
        # causing any 0.12.2 release to satisfy a requirement for the dev build

        local required_version="0.12.2-dev"

        # sort -V order: 0.12.1 < 0.12.2-dev < 0.12.2
        # So: 0.12.1 fails (correct), 0.12.2-dev passes (correct), 0.12.2 passes (correct)
        if printf '%s\n%s\n' "$required_version" "$ver" | sort -V -C; then
            printf '%b[+]%b Neovim version check passed: %s\n' "${GREEN}" "${NC}" "$ver"
        else
            printf '%b[-]%b Required: %s — Found: %s\n' "${RED}" "${NC}" "$required_version" "$ver"
            printf '%b[+]%b Building required dev version from source...\n' "${CYAN}" "${NC}"
            # No prompt — if the version fails for a dev build requirement there is
            # no alternative. The script's entire purpose requires this specific build.
            build_neovim
        fi
        return 0
}

build_neovim() {
        debug "build_neovim"
        printf '%b[+]%b Building Neovim from source...\n' "${CYAN}" "${NC}"

        if command -v nvim &>/dev/null; then
            printf '%b[?]%b Remove existing Neovim installation? (yes/no): ' "${CYAN}" "${NC}"
            read -r -p "" remove_existing
            remove_existing="${remove_existing:-no}"
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
                    *)
                        printf '%b[-]%b Unsupported package manager: %s\n' "${RED}" "${NC}" "$PKG_MANAGER"
                        exit 1
                    ;;
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
            *)
                printf '%b[-]%b Unsupported package manager: %s\n' "${RED}" "${NC}" "$PKG_MANAGER"
                exit 1
            ;;
        esac
        eval "$cmd"

        BUILD_DIR="/tmp/nvim-build-$$-$RANDOM"
        if ! mkdir -p "$build_dir" 2>/dev/null; then
            printf '%b[-]%b Failed to create temporary build directory.\n' "${RED}" "${NC}"
            exit 1
        fi
        # trap 'rm -rf "$BUILD_DIR"' EXIT
        # Safe trap — no-op if BUILD_DIR was never set to a real path
        trap '[[ -n "$BUILD_DIR" ]] && rm -rf "$BUILD_DIR"' EXIT

        cd "$BUILD_DIR" || {
            printf '%b[-]%b Failed to cd to %s\n' "${RED}" "${NC}" "$build_dir"
            exit 1
        }

        if ! git clone https://github.com/neovim/neovim.git; then
            printf '%b[-]%b Failed to clone Neovim repository.\n' "${RED}" "${NC}"
            exit 1
        fi

        cd neovim || {
            printf '%b[-]%b Failed to cd to neovim\n' "${RED}" "${NC}"
            exit 1
        }

        # FIX — nightly branch, not stable
        # stable tracks releases (0.10.x, 0.11.x).
        # 0.12.2-dev lives on nightly. Checking out stable would build
        # the wrong version and the version check would fail again immediately.
        if ! git checkout nightly; then
            printf '%b[-]%b Failed to checkout nightly branch.\n' "${RED}" "${NC}"
            exit 1
        fi

        printf '%b[+]%b Building Neovim (this may take a while)...\n' "${CYAN}" "${NC}"
        if ! make -j"$NPROC" CMAKE_BUILD_TYPE=RelWithDebInfo; then
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
        IFS= read -r installed_version < <(nvim --version)
        printf '%b[+]%b Installed: %s\n' "${GREEN}" "${NC}" "$installed_version"
        return 0
}

install_nvim_config_deps() {
        debug "install_nvim_config_deps"
        printf '%b[+]%b Installing config dependencies for %s using %s...\n' \
            "${CYAN}" "${NC}" "$DISTRO" "$PKG_MANAGER"

        local cmd=""
        case "$PKG_MANAGER" in
            "apt") cmd="sudo apt install -y libtree-sitter-dev nodejs npm shellcheck ripgrep" ;;
            "dnf")    cmd="sudo dnf update -y && sudo dnf install -y tree-sitter tree-sitter-cli nodejs npm ripgrep" ;;
            "pacman") cmd="sudo pacman -S --noconfirm tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
            "apk")    cmd="sudo apk add --no-cache tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
            "pkg")    cmd="sudo pkg install -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
            "zypper") cmd="sudo zypper install -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
            "xbps")   cmd="sudo xbps-install -S -y tree-sitter tree-sitter-cli nodejs npm shellcheck ripgrep" ;;
            "brew")   cmd="brew install tree-sitter node shellcheck ripgrep" ;;
            *)
                printf '%b[-]%b Unsupported package manager: %s\n' "${RED}" "${NC}" "$PKG_MANAGER"
                exit 1
            ;;
        esac
        eval "$cmd"
        return 0
}

install_tree_sitter_cli() {
        debug "install_tree_sitter_cli"
        if ! command -v tree-sitter &>/dev/null; then
            printf '%b[+]%b Installing tree-sitter-cli via npm...\n' "${CYAN}" "${NC}"
            if ! npm install -g tree-sitter-cli; then
                printf '%b[!]%b tree-sitter-cli install failed — Neovim will still work,\n' "${YELLOW}" "${NC}"
                printf '%b    but you cannot compile custom grammars.\n' "${YELLOW}"
            fi
        else
            printf '%b[+]%b tree-sitter-cli already installed.\n' "${GREEN}" "${NC}"
        fi
        return 0
}

remove_old_config() {
        debug "remove_old_config"
        printf '%b[+]%b Removing old Neovim configuration...\n' "${CYAN}" "${NC}"
        rm -rf ~/.config/nvim ~/.local/share/nvim

        # BUG 7 FIX — pointless sleep 2 removed
        # ORIGINAL: sleep 2  (after rm -rf)
        # rm is a synchronous call — it does not return until all files are deleted.
        # The kernel guarantees this. There is nothing asynchronous to wait for.
        # The sleep wasted 2 seconds on every install run for no reason.
        return 0
}

mk_nvim_dir() {
        debug "mk_nvim_dir"

        # BUG 8 FIX — redundant post-mkdir existence check
        # ORIGINAL: mkdir -p ...; if [[ -d ... ]]; then ... else ... exit 1
        # mkdir -p exits non-zero only on genuine failure (permissions, bad path).
        # It does NOT fail if the directory already exists — that is the purpose of -p.
        # Checking [[ -d ]] after a successful mkdir is always true and adds nothing.
        # FIX: test mkdir's exit code directly with if !. This is the correct pattern:
        # one operation, one check, no redundancy.
        if ! mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" 2>/dev/null; then
            printf '%b[-]%b Failed to create Neovim configuration directory.\n' "${RED}" "${NC}"
            printf '%b    Please run manually: mkdir -p ~/.config/nvim\n' "${RED}"
            exit 1
        fi
        printf '%b[+]%b Neovim configuration directory ready.\n' "${GREEN}" "${NC}"
        return 0
}

install_config() {
        debug "install_config"
        printf '%b[+]%b Cloning Neovim config — open Neovim after to install plugins...\n' "${CYAN}" "${NC}"

        if ! git clone https://github.com/LinuxUser255/nvim.git \
                "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"; then
            printf '%b[-]%b Failed to clone configuration repository.\n' "${RED}" "${NC}"
            printf '%b    The directory may not be empty. Try running the script again.\n' "${RED}"
            exit 1
        fi
        printf '%b[+]%b Configuration cloned successfully.\n' "${GREEN}" "${NC}"
        return 0
}

main() {
        debug "main"

        # BUG 9 FIX — run_parallel_tasks removed entirely; both functions called twice
        #
        # The original main() had THREE critical problems with run_parallel_tasks:
        #
        # PROBLEM A — Double execution
        # ORIGINAL:
        #   run_parallel_tasks parallel_results full_sys_upgrade install_nvim_config_deps
        #   full_sys_upgrade          ← called again!
        #   install_nvim_config_deps  ← called again!
        # Both functions ran in background via run_parallel_tasks, AND then ran again
        # sequentially. Every package install happened twice. The system upgrade ran
        # twice. This was a straightforward copy-paste error — the explicit sequential
        # calls were left in after the parallel wrapper was added.
        #
        # PROBLEM B — Package manager lock file conflict
        # Package managers use exclusive lock files to prevent concurrent access:
        #   apt   → /var/lib/dpkg/lock-frontend
        #   dnf   → /var/lib/rpm/.rpm.lock
        #   pacman → /var/lib/pacman/db.lck
        # full_sys_upgrade and install_nvim_config_deps both call the same package
        # manager. Running them in parallel guarantees that the second job hits a
        # locked package database and fails with an error like:
        #   "dpkg: error: dpkg frontend is locked by another process"
        # These two functions CANNOT run in parallel — they are sequential by nature.
        #
        # PROBLEM C — Background jobs cannot modify parent shell variables
        # Functions run via & execute in a subshell (fork of the current shell).
        # Any variable the background function modifies (like PKG_MANAGER or DISTRO)
        # is modified in the child's copy of memory. When the child exits, those
        # changes vanish. The parent shell never sees them. This makes parallelizing
        # setup/detection functions that set globals entirely pointless.
        #
        # FIX: remove run_parallel_tasks completely. Run the two functions sequentially.
        # They must run in order because install_nvim_config_deps depends on PKG_MANAGER
        # being set, and both call the same package manager which cannot be concurrent.
        # Sequential here is not a performance regression — it is the only correct approach.

        print_banner
        install_prompt
        get_os
        detect_distro          # no argument — nameref removed (Bug 4 fix)
        full_sys_upgrade
        check_neovim_version   # no argument — nameref removed (Bug 5 fix)
        install_nvim_config_deps
        install_tree_sitter_cli
        remove_old_config
        mk_nvim_dir
        install_config
        return 0
}

main "$@"

