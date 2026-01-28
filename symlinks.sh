#!/bin/bash

# Dotfiles symlink setup script
# Run this script from anywhere to symlink your dotfiles

# How to use:
# 1. Clone your dotfiles to ~/dotfiles
# 2. Run: chmod +x ~/dotfiles/symlinks.sh && ~/dotfiles/symlinks.sh

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "Setting up dotfiles symlinks..."

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local target_dir=$(dirname "$target")

    # Create target directory if it doesn't exist
    if [ ! -d "$target_dir" ]; then
        echo "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing file: $target -> $target.backup"
        mv "$target" "$target.backup"
    fi

    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm "$target"
    fi

    echo "Linking: $source -> $target"
    ln -s "$source" "$target"
}

# Zed editor
create_symlink "$DOTFILES_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
create_symlink "$DOTFILES_DIR/zed/keymap.json" "$HOME/.config/zed/keymap.json"

# IdeaVim (JetBrains IDEs)
create_symlink "$DOTFILES_DIR/.ideavimrc" "$HOME/.ideavimrc"

echo "Dotfiles setup complete!"
