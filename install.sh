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
echo "  6) MCP servers only"
echo ""
read -p "Choose option [1-6]: " INSTALL_OPTION

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

install_mcp_servers() {
    echo ""
    echo "🌐 Installing MCP servers..."

    # Serena - Semantic code analysis
    read -p "Install Serena MCP? (semantic code analysis) [y/N]: " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        claude mcp add -s user serena -- uvx --from git+https://github.com/oraios/serena serena-mcp-server --context ide-assistant
        echo "  ✓ Added Serena MCP"
    fi

    # Chrome DevTools - Browser automation
    read -p "Install Chrome DevTools MCP? (browser automation) [y/N]: " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        claude mcp add -s user chrome-devtools -- npx chrome-devtools-mcp@latest
        echo "  ✓ Added Chrome DevTools MCP"
    fi

    # Context7 - Up-to-date documentation
    read -p "Install Context7 MCP? (up-to-date docs) [y/N]: " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        read -p "  Enter Context7 API key (or press Enter to skip): " api_key
        if [ -n "$api_key" ]; then
            claude mcp add -s user context7 -- npx -y @upstash/context7-mcp --api-key "$api_key"
        else
            claude mcp add -s user context7 -- npx -y @upstash/context7-mcp
        fi
        echo "  ✓ Added Context7 MCP"
    fi
}

case $INSTALL_OPTION in
    1)
        install_agents
        install_skills
        install_commands
        install_hooks
        install_mcp_servers
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

        read -p "Install MCP servers? [y/N]: " ans
        [[ "$ans" =~ ^[Yy]$ ]] && install_mcp_servers
        ;;
    6)
        install_mcp_servers
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
