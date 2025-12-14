#!/bin/bash

# Claude Code Power Pack Installer
# Creates symbolic links from ~/.claude to this repository

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "🚀 Claude Code Power Pack Installer"
echo "===================================="
echo ""
echo "This will create symbolic links from ~/.claude to:"
echo "  $SCRIPT_DIR"
echo ""

# Check if ~/.claude exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Creating ~/.claude directory..."
    mkdir -p "$CLAUDE_DIR"
fi

# Function to create directory if not exists
ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}

# Function to backup existing file/directory
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        echo "  Backing up existing $target to $backup"
        mv "$target" "$backup"
    elif [ -L "$target" ]; then
        echo "  Removing existing symlink $target"
        rm "$target"
    fi
}

# Ask for installation type
echo "Installation options:"
echo "  1) Full installation (all components)"
echo "  2) Agents only"
echo "  3) Skills only"
echo "  4) Commands only"
echo "  5) Custom selection"
echo ""
read -p "Choose option [1-5]: " INSTALL_OPTION

install_agents() {
    echo ""
    echo "📦 Installing agents..."
    ensure_dir "$CLAUDE_DIR/agents"

    for agent in "$SCRIPT_DIR/agents"/*.md; do
        if [ -f "$agent" ]; then
            basename=$(basename "$agent")
            target="$CLAUDE_DIR/agents/$basename"
            backup_if_exists "$target"
            ln -s "$agent" "$target"
            echo "  ✓ Linked $basename"
        fi
    done
}

install_skills() {
    echo ""
    echo "🎯 Installing skills..."
    ensure_dir "$CLAUDE_DIR/skills"

    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            target="$CLAUDE_DIR/skills/$skill_name"
            backup_if_exists "$target"
            ln -s "$skill_dir" "$target"
            echo "  ✓ Linked $skill_name"
        fi
    done
}

install_commands() {
    echo ""
    echo "⚡ Installing commands..."
    ensure_dir "$CLAUDE_DIR/commands"

    for command in "$SCRIPT_DIR/commands"/*.md; do
        if [ -f "$command" ]; then
            basename=$(basename "$command")
            target="$CLAUDE_DIR/commands/$basename"
            backup_if_exists "$target"
            ln -s "$command" "$target"
            echo "  ✓ Linked $basename"
        fi
    done
}

install_hooks() {
    echo ""
    echo "🔗 Installing hooks..."
    ensure_dir "$CLAUDE_DIR/hooks"

    for hook in "$SCRIPT_DIR/hooks"/*; do
        if [ -f "$hook" ]; then
            basename=$(basename "$hook")
            target="$CLAUDE_DIR/hooks/$basename"
            backup_if_exists "$target"
            ln -s "$hook" "$target"
            chmod +x "$hook"
            echo "  ✓ Linked $basename"
        fi
    done
}

case $INSTALL_OPTION in
    1)
        install_agents
        install_skills
        install_commands
        install_hooks
        ;;
    2)
        install_agents
        ;;
    3)
        install_skills
        ;;
    4)
        install_commands
        ;;
    5)
        read -p "Install agents? [y/N]: " ans
        [[ "$ans" =~ ^[Yy]$ ]] && install_agents

        read -p "Install skills? [y/N]: " ans
        [[ "$ans" =~ ^[Yy]$ ]] && install_skills

        read -p "Install commands? [y/N]: " ans
        [[ "$ans" =~ ^[Yy]$ ]] && install_commands

        read -p "Install hooks? [y/N]: " ans
        [[ "$ans" =~ ^[Yy]$ ]] && install_hooks
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Review your ~/.claude/settings.json"
echo "  2. Add agent configurations if needed"
echo "  3. Restart Claude Code to load new components"
echo ""
echo "For usage examples, see: $SCRIPT_DIR/README.md"
echo ""
echo "wonderful!! 🎉"
