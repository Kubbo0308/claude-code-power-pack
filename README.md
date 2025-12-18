# Claude Code Power Pack

A toolkit of subagents, skills, and commands for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Features

### Subagents (21)

| Category | Agent | Description |
|----------|-------|-------------|
| **Git Workflow** | `commit` | Conventional Commits with proper formatting |
| | `pull-request` | PR creation with structured summaries |
| | `pre-commit-checker` | Visual diff review before commits |
| **Code Review** | `security` | OWASP Top 10 & vulnerability analysis |
| | `review` | Comprehensive code review |
| | `go-reviewer` | Go-specific code review |
| | `typescript-reviewer` | TypeScript/React code review |
| | `terraform-reviewer` | Terraform/IaC review |
| | `dbt-reviewer` | dbt SQL review |
| | `markdown-reviewer` | Documentation review |
| **Testing** | `typescript-test-generator` | Jest/RTL tests with DRY principles |
| | `go-test-generater` | Table-driven Go tests |
| | `test` | General test generation |
| **Decision Support** | `magi-melchior` | Technical/scientific analysis |
| | `magi-balthasar` | Human factors & ethics |
| | `magi-casper` | Practical constraints |
| **Analysis** | `github-analyzer` | GitHub repo analysis |
| **Development** | `typescript-developer` | TypeScript development support |
| | `task-decomposer` | Complex task breakdown |
| | `document` | Documentation generation |
| | `drawio-diagram-generator` | Draw.io diagram creation |

### Skills (4)

| Skill | Focus Areas |
|-------|-------------|
| **code-review** | Quality, Security, Performance, Maintainability |
| **go-testing** | Table-driven tests, Mocking, Test organization |
| **database-admin** | Schema design, Query optimization, Performance |
| **drawio** | XML structure, Font settings, Arrow placement |

### Slash Commands (5)

| Command | Description |
|---------|-------------|
| `/magi` | 3-agent parallel decision support system |
| `/mr` | Multi-agent code review (language-specific) |
| `/sync-main` | Safe branch synchronization |
| `/create-pr` | PR workflow guide |
| `/orchestrator` | Complex task orchestration |

### Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `on-clear.sh` | `/clear` command | Reminds to sync with main branch |

## Installation

### Option 1: /plugin Command (Recommended)

Install directly within Claude Code session:

```bash
# Add marketplace
/plugin marketplace add YOUR_USERNAME/claude-code-power-pack

# Install plugin
/plugin install power-pack@YOUR_USERNAME
```

That's it! No manual setup required.

### Option 2: Manual Installation

For local customization without plugin format:

```bash
git clone https://github.com/YOUR_USERNAME/claude-code-power-pack.git
cd claude-code-power-pack
./install.sh
```

Or copy manually:

```bash
cp -r agents/* ~/.claude/agents/
cp -r skills/* ~/.claude/skills/
cp -r commands/* ~/.claude/commands/
cp -r hooks/* ~/.claude/hooks/
```

## Usage Examples

### MAGI Decision Support

```
/magi Should we use Redux or React Context for state management?
```

### Multi-Agent Code Review

```
/mr        # Normal mode
/mr --auto # Auto-fix mode
```

### Pre-Commit Workflow

1. Make changes
2. Run `pre-commit-checker` subagent
3. Review diff
4. Run `commit` subagent

## Recommended MCP Servers

### Serena

Semantic code analysis with symbol-level understanding.

```bash
claude mcp add -s user serena -- uvx --from git+https://github.com/oraios/serena serena-mcp-server --context ide-assistant
```

**Features:** Symbol search, reference finding, semantic code editing

### Chrome DevTools

Browser automation and debugging.

```bash
claude mcp add -s user chrome-devtools -- npx chrome-devtools-mcp@latest
```

**Features:** Page snapshots, click/fill actions, network inspection, screenshots

### Context7

Up-to-date documentation and code examples for libraries/frameworks.

```bash
# With API key (recommended)
claude mcp add -s user context7 -- npx -y @upstash/context7-mcp --api-key YOUR_API_KEY

# Without API key
claude mcp add -s user context7 -- npx -y @upstash/context7-mcp
```

Get API key at [context7.com/dashboard](https://context7.com/dashboard)

**Usage:** Add "use context7" to your prompts for latest documentation.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- Optional: `npx difit` for visual diff
- Optional: Context7 MCP for up-to-date docs

## Project Structure

```
claude-code-power-pack/
├── agents/           # 21 subagents
├── skills/           # 4 skills with references
├── commands/         # 5 slash commands
├── hooks/            # Event hooks
├── settings.example.json
├── install.sh
└── README.md
```

## License

MIT
