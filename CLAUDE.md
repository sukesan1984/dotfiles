# Claude Code Project Context

## Project Overview
This is a dotfiles repository for managing development environment configurations using Nix Home Manager.

## Key Technologies
- **Nix/Home Manager**: Package and configuration management
- **Neovim**: Main text editor with LSP support
- **Python**: Development with Ruff for linting/formatting
- **Go**: Development with gopls and vim-go
- **Zsh**: Shell configuration
- **tmux**: Terminal multiplexer

## Important Commands
### Build and Apply Configuration
```bash
home-manager switch
```

### Python Development
- **Linting**: Handled by Ruff LSP
- **Type Checking**: Using Pyright
- **Formatting**: Ruff formatter (should run on save)

### Testing
Please provide the specific test commands used in this project.

## Project Structure
- `home.nix`: Main Home Manager configuration
- `.config/nvim/init.lua`: Neovim configuration
- `.zshrc`: Zsh shell configuration
- `.tmux.conf`: tmux configuration

## Known Issues
- Ruff formatter on save might not be working correctly in Neovim
- Need to configure Pyrefly as an alternative to Pyright

## Notes
- Using iTerm2 terminal with imgcat support for displaying images
- Python files should use 4-space indentation (PEP 8 standard)
- Line numbers in Neovim are styled for better visibility