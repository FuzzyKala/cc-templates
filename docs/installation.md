# Installation Guide

## Quick Installation

### Prerequisites
- Git
- GitHub CLI (optional, for repository management)
- Claude Code CLI environment

### One-Line Installation
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-session-management-templates/main/scripts/install.sh | bash
```

### Manual Installation

#### 1. Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/claude-session-management-templates.git ~/.claude-templates
```

#### 2. Make Scripts Executable
```bash
chmod +x ~/.claude-templates/scripts/install.sh
```

#### 3. Add to PATH (Optional)
Add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):
```bash
export PATH="$HOME/.claude-templates/scripts:$PATH"
alias claude-init='~/.claude-templates/scripts/install.sh'
```

#### 4. Initialize Your First Project
```bash
cd /path/to/your/project
~/.claude-templates/scripts/install.sh
```

## Verification

After installation, you should have:
- `~/.claude-templates/` directory with all templates
- Executable installation script
- Access to project initialization

Test your installation:
```bash
ls ~/.claude-templates/
# Should show: agents/ commands/ system/ project-templates/ scripts/ docs/
```

## Troubleshooting

### Permission Issues
```bash
chmod -R 755 ~/.claude-templates/
chmod +x ~/.claude-templates/scripts/install.sh
```

### Path Issues
Make sure the templates directory is accessible:
```bash
echo $HOME/.claude-templates
ls -la ~/.claude-templates/
```

### GitHub CLI Not Found
Install GitHub CLI for repository management:
- **Ubuntu/Debian**: `sudo apt install gh`
- **macOS**: `brew install gh`
- **Windows**: `winget install GitHub.cli`

## Next Steps

After installation:
1. Read the [Setup Guide](../setup-guide.md)
2. Try the [Quick Start](../README.md#quick-start)
3. Review [Project Examples](../examples/)
4. Customize agents for your needs