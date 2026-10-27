#!/bin/bash

# Dotfiles symlink setup script
# Run this script from anywhere to symlink your dotfiles

# How to use:
# 1. Clone your dotfiles to ~/dotfiles
# 2. Run: chmod +x ~/dotfiles/symlinks.sh && ~/dotfiles/symlinks.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

echo "Setting up dotfiles symlinks..."

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local target_dir
    target_dir=$(dirname "$target")

    if [ ! -e "$source" ]; then
        echo "Missing dotfile source: $source" >&2
        return 1
    fi

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "Already linked: $target"
        return 0
    fi

    mkdir -p "$target_dir"

    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="$target.backup" suffix=1
        while [ -e "$backup" ] || [ -L "$backup" ]; do
            backup="$target.backup.$suffix"
            suffix=$((suffix + 1))
        done
        echo "Backing up existing config: $target -> $backup"
        mv "$target" "$backup"
    fi

    echo "Linking: $source -> $target"
    ln -s "$source" "$target"
}

# Zed editor
case "$OS" in
    Darwin|Linux) ZED_CONFIG_DIR="$HOME/.config/zed" ;;
    MINGW*|MSYS*|CYGWIN*) ZED_CONFIG_DIR="$HOME/AppData/Roaming/Zed" ;;
    *) echo "Unsupported platform: $OS" >&2; exit 1 ;;
esac
create_symlink "$DOTFILES_DIR/zed/settings.json" "$ZED_CONFIG_DIR/settings.json"
create_symlink "$DOTFILES_DIR/zed/keymap.json" "$ZED_CONFIG_DIR/keymap.json"

# macOS desktop apps are not configured on Windows or Linux.
if [ "$OS" = "Darwin" ]; then
    create_symlink "$DOTFILES_DIR/macos/sketchybar" "$HOME/.config/sketchybar"
fi

# Neovim
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# IdeaVim (JetBrains IDEs)
create_symlink "$DOTFILES_DIR/.ideavimrc" "$HOME/.ideavimrc"

# Agent Skills
create_symlink "$DOTFILES_DIR/skills" "$HOME/.agents/skills"

echo "Dotfiles setup complete!"
