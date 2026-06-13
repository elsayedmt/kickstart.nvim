# Telescope.nvim Documentation

## Overview

Telescope.nvim is a highly extendable fuzzy finder over lists built entirely in Lua for Neovim. It provides a unified interface for searching, filtering, and selecting from various data sources through a consistent picker-based UI architecture. The plugin is centered around modularity, allowing for easy customization and extension.

**Repository**: [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Key Features

- **Fuzzy Finding**: Advanced fuzzy search capabilities across multiple data sources
- **Modular Architecture**: Centered around modularity with customizable pickers, finders, sorters, and previewers
- **Live Preview**: Real-time preview of files, symbols, and other content
- **Extensible**: Rich ecosystem of extensions for enhanced functionality
- **LSP Integration**: Deep integration with Language Server Protocol features
- **Git Integration**: Built-in Git functionality for searching repositories
- **Performance**: Native sorters available for improved performance
- **Customizable**: Highly configurable mappings, themes, and behavior

## Installation

### Requirements

- **Neovim**: v0.9.0 or nightly commit (compiled with LuaJIT)
- **Dependencies**: `nvim-lua/plenary.nvim` (required)
- **Recommended**: `ripgrep` for enhanced file searching performance

### Basic Installation

```lua
-- Using lazy.nvim
{
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8', -- Use latest stable version
  dependencies = { 'nvim-lua/plenary.nvim' }
}
```

### Recommended Extensions

```lua
{
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make' -- or cmake, see extension docs
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
  }
}
```

## Configuration

### Basic Setup

```lua
require('telescope').setup {
  defaults = {
    -- Default configuration for all pickers
    prompt_prefix = "> ",
    selection_caret = "> ",
    path_display = { "truncate" },
    file_ignore_patterns = { "node_modules" },

    mappings = {
      i = {
        ["<C-h>"] = "which_key", -- Show help
        ["<C-u>"] = false,       -- Clear prompt
        ["<C-d>"] = false,       -- Scroll preview down
      },
      n = {
        ["q"] = require("telescope.actions").close,
      },
    },
  },

  pickers = {
    -- Configure specific pickers
    find_files = {
      theme = "dropdown",
      previewer = false,
    },
    live_grep = {
      additional_args = function(opts)
        return {"--hidden"}
      end
    },
  },

  extensions = {
    -- Extension configurations
  }
}
```

### Loading Extensions

```lua
-- Load extensions after setup
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
```

## Built-in Pickers

### File Pickers

- **`find_files`**: Search files in current directory
- **`git_files`**: Search Git-tracked files
- **`grep_string`**: Search for string under cursor
- **`live_grep`**: Live grep search across files
- **`oldfiles`**: Recently opened files

### Vim Pickers

- **`buffers`**: List open buffers
- **`colorscheme`**: Available colorschemes
- **`commands`**: Available commands
- **`command_history`**: Command history
- **`help_tags`**: Help documentation
- **`keymaps`**: Current keymaps
- **`marks`**: Vim marks
- **`registers`**: Vim registers
- **`search_history`**: Search history

### LSP Pickers

- **`lsp_references`**: Find symbol references
- **`lsp_definitions`**: Go to symbol definition
- **`lsp_type_definitions`**: Go to type definition
- **`lsp_implementations`**: Find implementations
- **`lsp_document_symbols`**: Symbols in current document
- **`lsp_workspace_symbols`**: Symbols in workspace
- **`lsp_dynamic_workspace_symbols`**: Dynamic workspace symbols
- **`diagnostics`**: LSP diagnostics

### Git Pickers

- **`git_commits`**: Git commit history
- **`git_bcommits`**: Buffer's Git history
- **`git_branches`**: Git branches
- **`git_status`**: Git status
- **`git_stash`**: Git stash

## Usage Examples

### Basic Usage

```lua
-- Search files
:Telescope find_files

-- Live grep
:Telescope live_grep

-- Search help tags
:Telescope help_tags

-- Show all available pickers
:Telescope builtin
```

### Keybinding Examples

```lua
local builtin = require('telescope.builtin')

-- File operations
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })

-- LSP operations
vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = '[G]oto [R]eferences' })
vim.keymap.set('n', 'gi', builtin.lsp_implementations, { desc = '[G]oto [I]mplementation' })

-- Git operations
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
```

### Custom Picker Configuration

```lua
-- Custom find_files with specific options
vim.keymap.set('n', '<leader>sf', function()
  builtin.find_files({
    hidden = true,
    file_ignore_patterns = { ".git/", "node_modules/" },
    prompt_title = "Find Files (including hidden)",
  })
end, { desc = '[S]earch [F]iles' })

-- Current buffer fuzzy search
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
```

## Extensions

### telescope-fzf-native.nvim

Provides native FZF sorter for significant performance improvements.

```lua
-- Installation
{
  'nvim-telescope/telescope-fzf-native.nvim',
  build = 'make' -- or 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
}

-- Configuration
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}
require('telescope').load_extension('fzf')
```

### telescope-ui-select.nvim

Replaces `vim.ui.select` with Telescope picker.

```lua
-- Configuration
require('telescope').setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown()
    }
  }
}
require('telescope').load_extension('ui-select')
```

### telescope-file-browser.nvim

File system browser with file and folder management capabilities.

```lua
-- Installation and configuration
{
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
}

require('telescope').setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      hijack_netrw = true,
      mappings = {
        ["i"] = {},
        ["n"] = {},
      },
    },
  },
}
require('telescope').load_extension('file_browser')

-- Usage
vim.keymap.set('n', '<leader>fb', ':Telescope file_browser<CR>')
```

## Advanced Configuration

### Custom Themes

```lua
local themes = require('telescope.themes')

-- Dropdown theme
builtin.find_files(themes.get_dropdown({
  winblend = 10,
  previewer = false,
}))

-- Ivy theme
builtin.live_grep(themes.get_ivy())

-- Cursor theme
builtin.buffers(themes.get_cursor({
  initial_mode = "normal"
}))
```

### Custom Actions

```lua
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-a>"] = actions.select_all,
        ["<C-x>"] = actions.delete_buffer,
      },
      n = {
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
    },
  },
}
```

### Performance Optimization

```lua
require('telescope').setup {
  defaults = {
    -- Optimize for large repositories
    file_ignore_patterns = {
      "%.git/",
      "node_modules/",
      "%.npm/",
      "%.cache/",
      "build/",
      "dist/",
    },

    -- Reduce initial file scanning
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
  },
}
```

## Common Use Cases

1. **File Navigation**: Quick file finding and switching
2. **Code Search**: Search for functions, variables, or text across project
3. **LSP Integration**: Navigate code using language server features
4. **Git Workflow**: Browse commits, branches, and status
5. **Help System**: Search Neovim documentation and help tags
6. **Buffer Management**: Switch between open buffers efficiently
7. **Configuration Discovery**: Find and modify configuration files

## Related Plugins and Alternatives

### Complementary Plugins

- **nvim-tree.lua**: File tree explorer (different UI paradigm)
- **neo-tree.nvim**: Modern file tree with Telescope integration
- **fzf.vim**: Vim wrapper for FZF (different approach)
- **ctrlp.vim**: Classic fuzzy file finder

### Alternative Fuzzy Finders

- **fzf.vim**: Command-line fuzzy finder integration
- **LeaderF**: Python-based fuzzy finder
- **denite.nvim**: Unite successor with async support

## Troubleshooting

### Health Check

Run `:checkhealth telescope` after installation to ensure proper setup.

### Common Issues

1. **Performance**: Install `telescope-fzf-native.nvim` for better performance
2. **Missing ripgrep**: Install `ripgrep` for optimal grep functionality
3. **Build errors**: Ensure build tools (make/cmake) are available for native extensions
4. **Slow startup**: Optimize file ignore patterns and use lazy loading

### Debugging

```lua
-- Enable telescope debugging
require('telescope.config').set_log_level('debug')

-- Check telescope configuration
:Telescope builtin
```

## Current Configuration in This Setup

This Neovim configuration uses Telescope with the following setup:

- **Extensions**: `telescope-fzf-native.nvim` and `telescope-ui-select.nvim`
- **LSP Integration**: Full integration with LSP features
- **Keybindings**: Comprehensive keymaps under `<leader>s` prefix
- **Theme**: UI-select uses dropdown theme
- **Performance**: FZF native sorter enabled for better performance

The configuration prioritizes functionality and developer experience while maintaining the educational philosophy of kickstart.nvim.