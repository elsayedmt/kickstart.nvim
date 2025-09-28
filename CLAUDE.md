# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personalized Neovim configuration based on kickstart.nvim, a minimal starting point for Neovim that emphasizes being small, single-file, and completely documented.

## Key Architecture

### Configuration Structure
- **Main entry point**: `init.lua` - Contains the core configuration with lazy.nvim plugin management
- **Custom modules**: `lua/haroona/` - Personal configuration modules
- **Custom plugins**: `lua/custom/plugins/` - Additional plugin configurations beyond kickstart defaults
- **Kickstart plugins**: `lua/kickstart/plugins/` - Standard kickstart plugin configurations

### Plugin Management
- Uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager
- Plugins are configured in modular files under `lua/custom/plugins/`
- Core plugins from kickstart are maintained in `lua/kickstart/plugins/`

### Key Custom Configurations

#### Theme and UI
- Primary colorscheme: TokyoNight (configured in init.lua)
- Alternative theme available: Kanagawa (disabled in custom/plugins/kanagawa.lua)
- Snacks.nvim provides comprehensive UI enhancements including dashboard, explorer, notifications

#### Language Support
- **Rust**: Full support with rustaceanvim and crates.nvim for Cargo.toml management
- **Terraform**: Custom filetype detection and terraformls LSP configured
- **TypeScript**: TypeScript tools integration available
- **Lua**: Full LSP support with lua_ls

#### AI Integration
- ChatGPT integration via ChatGPT.nvim plugin
- Extensive keybindings under `<leader>C` for AI-powered code assistance
- Supports code completion, editing, optimization, and documentation generation

#### Key Custom Keybindings
- ChatGPT functions: `<leader>C*` (complete, edit, translate, optimize, etc.)
- Snacks.nvim picker and utilities override many default telescope bindings
- Custom file explorer and search functionality via Snacks

## Common Commands

### Plugin Management
- `:Lazy` - Open lazy.nvim plugin manager interface
- `:Lazy update` - Update all plugins
- `:Mason` - Open Mason LSP/tool installer interface

### Code Formatting
- `stylua` is configured for Lua code formatting
- Format on save is enabled for most file types (disabled for C/C++)
- Manual formatting: `<leader>f`

### Development Workflow
- LSP features available for supported languages (see servers configuration in init.lua)
- Auto-completion via blink.cmp
- Git integration through multiple plugins (gitsigns, neogit, fugitive, snacks git features)
- File exploration via Neo-tree and Snacks explorer

### Testing and Linting
- Stylua formatting enforced via GitHub workflow
- Conform.nvim handles formatting
- Linting available through kickstart lint plugin

## Configuration Patterns

### Plugin Structure
Custom plugins follow this pattern in `lua/custom/plugins/*.lua`:
```lua
return {
  'plugin-name',
  config = function()
    -- plugin setup
  end,
  dependencies = { ... },
  opts = { ... }
}
```

### Keymap Organization
- Uses which-key.nvim for discoverable keybindings
- Keymaps organized by functional groups (search, git, ai, etc.)
- Extensive use of leader key combinations

### Filetype-specific Configuration
- Terraform files get custom filetype detection
- Rust-specific configurations in `after/ftplugin/rust.lua`
- TOML-specific configurations for Cargo support

## Important Notes

- This configuration extends kickstart.nvim while maintaining its educational philosophy
- The main init.lua contains extensive documentation explaining each configuration choice
- Custom additions are clearly separated from kickstart defaults
- Configuration prioritizes functionality and developer experience over minimalism