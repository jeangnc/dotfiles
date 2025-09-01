#!/usr/bin/env bash

set -e

# Define packages to install/uninstall
PACKAGES=("zsh" "git" "kitty" "nvim" "tmux" "claude")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if stow is installed
check_stow() {
    if ! command -v stow &> /dev/null; then
        error "GNU Stow is not installed!"
        echo "Install it with:"
        echo "  macOS: brew install stow"
        echo "  Ubuntu/Debian: sudo apt install stow"
        echo "  Fedora: sudo dnf install stow"
        exit 1
    fi
}

# Install packages using stow
install_package() {
    local package=$1
    log "Installing $package..."
    
    if stow --target="$HOME" "$package"; then
        success "$package installed successfully"
    else
        error "Failed to install $package"
        warn "Check for conflicts in your home directory"
        return 1
    fi
}

# Main installation
main() {
    log "Starting dotfiles installation with GNU Stow"
    
    # Check prerequisites
    check_stow
    
    # Change to dotfiles directory
    cd "$(dirname "$0")"
    
    # Install each package
    for package in "${PACKAGES[@]}"; do
        if [[ -d "$package" ]]; then
            install_package "$package"
        else
            warn "Package '$package' directory not found, skipping..."
        fi
    done
    
    success "Dotfiles installation completed!"
    log "You may need to restart your shell or source your config files"
}

# Handle command line arguments
case "${1:-install}" in
    "install")
        main
        ;;
    "uninstall")
        log "Uninstalling dotfiles..."
        cd "$(dirname "$0")"
        for package in "${PACKAGES[@]}"; do
            if [[ -d "$package" ]]; then
                log "Removing $package..."
                stow --target="$HOME" --delete "$package" || warn "Failed to remove $package"
            fi
        done
        success "Dotfiles uninstalled"
        ;;
    "restow")
        log "Re-installing dotfiles..."
        cd "$(dirname "$0")"
        for package in "${PACKAGES[@]}"; do
            if [[ -d "$package" ]]; then
                log "Re-stowing $package..."
                stow --target="$HOME" --restow "$package" || warn "Failed to restow $package"
            fi
        done
        success "Dotfiles re-installed"
        ;;
    *)
        echo "Usage: $0 [install|uninstall|restow]"
        echo "  install   - Install dotfiles (default)"
        echo "  uninstall - Remove all symlinks"
        echo "  restow    - Re-install (useful after changes)"
        exit 1
        ;;
esac