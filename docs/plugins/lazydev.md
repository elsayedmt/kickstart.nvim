# lazydev.nvim

A modern Neovim plugin that provides faster LuaLS setup by lazily updating workspace libraries for enhanced Lua development experience.

## Overview

**lazydev.nvim** is a performance-focused plugin developed by Folke Lemaitre that intelligently configures the Lua Language Server (LuaLS) for Neovim configuration and plugin development. Unlike traditional approaches that load all available libraries upfront, lazydev.nvim employs a "lazy loading" strategy, only adding modules to your workspace as they're actually used in your code.

This plugin serves as the modern replacement for the now-deprecated `neodev.nvim` and is specifically designed for Neovim >= 0.10.0.

## Key Features

### Performance Optimization
- **Faster Auto-completion**: Only loads modules that are actively `require`d in open files
- **Reduced Memory Usage**: Eliminates unnecessary library loading
- **Improved Responsiveness**: Significantly faster than traditional LSP setups

### Intelligent Library Management
- **Dynamic Loading**: Automatically detects and loads libraries based on:
  - `require("module-name")` statements
  - Module annotations like `---@module "module-name"`
  - Configurable trigger words
- **Third-party Support**: Seamless integration with LLS-Addons
- **Project-aware**: No manual configuration needed for different project types

### Modern Integration
- **Built-in Completion**: Native support for popular completion engines
- **LSP Optimization**: Proper workspace management for LuaLS
- **Flexible Configuration**: Extensive customization options

## Installation

### Using lazy.nvim (Recommended)

```lua
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
```

### Requirements
- **Neovim**: >= 0.10.0
- **LuaLS**: Lua Language Server
- **Plugin Manager**: lazy.nvim (recommended)

## Configuration

### Default Configuration

```lua
---@class lazydev.Config
local defaults = {
  runtime = vim.env.VIMRUNTIME --[[@as string]],
  library = {}, ---@type lazydev.Library.spec[]
  integrations = {
    -- Fixes lspconfig's workspace management for LuaLS
    lspconfig = true,
    -- Add cmp source for completion
    cmp = true,
    -- Coq integration (disabled by default)
    coq = false,
  },
  ---@type boolean|(fun(root:string):boolean?)
  enabled = function(root_dir)
    return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
  end,
}
```

### Library Configuration Examples

#### Basic Library Loading
```lua
library = {
  -- Simple library directory
  "lazy.nvim",

  -- Always load LazyVim library
  "LazyVim",

  -- Load library with specific directory
  "~/projects/my-plugin",
}
```

#### Conditional Library Loading
```lua
library = {
  -- Load based on trigger words
  { path = "${3rd}/luv/library", words = { "vim%.uv" } },

  -- Load when global is found
  { path = "LazyVim", words = { "LazyVim" } },

  -- Load when module is required
  { path = "wezterm-types", mods = { "wezterm" } },

  -- Load for specific files
  { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
}
```

#### Advanced Configuration
```lua
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- Neovim runtime
      { path = "luvit-meta/library", words = { "vim%.uv" } },
      -- LazyVim
      { path = "LazyVim", words = { "LazyVim" } },
      -- Plugin directories
      "lazy.nvim",
      "plenary.nvim",
      -- Conditional loading
      { path = "neotest", words = { "neotest" } },
      { path = "nvim-dap", words = { "dap" } },
    },
    integrations = {
      lspconfig = true,
      cmp = true,
    },
  },
}
```

## Usage Examples

### Basic Setup for Neovim Configuration

```lua
-- For editing your Neovim configuration
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- Essential libraries for Neovim config development
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      "lazy.nvim",
    },
  },
}
```

### Plugin Development Setup

```lua
-- For developing Neovim plugins
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- Common plugin dependencies
      "plenary.nvim",
      "nvim-treesitter",
      "telescope.nvim",
      -- Load based on usage
      { path = "neotest", mods = { "neotest" } },
      { path = "nvim-dap", mods = { "dap" } },
    },
  },
}
```

### Full-featured Setup

```lua
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- Core Neovim libraries
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },

      -- Plugin manager
      "lazy.nvim",

      -- Common dependencies
      "plenary.nvim",
      "nvim-web-devicons",

      -- UI frameworks
      { path = "telescope.nvim", words = { "telescope" } },
      { path = "nvim-tree.lua", words = { "nvim.tree", "nvim_tree" } },

      -- LSP related
      { path = "nvim-lspconfig", words = { "lspconfig" } },
      { path = "mason.nvim", words = { "mason" } },

      -- Testing
      { path = "neotest", words = { "neotest" } },

      -- Debugging
      { path = "nvim-dap", words = { "dap" } },

      -- Utility
      { path = "which-key.nvim", words = { "which.key", "which_key" } },
    },
  },
}
```

## Integration with LSP

### LuaLS Configuration
lazydev.nvim automatically configures LuaLS with optimal settings. No manual LSP configuration required.

### Workspace Management
The plugin intelligently manages workspace libraries, ensuring only relevant modules are loaded for each project.

### Performance Benefits
- Faster startup times for LSP
- Reduced memory usage
- More responsive completion

## Integration with Completion Engines

### nvim-cmp Integration

```lua
{
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    opts.sources = opts.sources or {}
    table.insert(opts.sources, {
      name = "lazydev",
      group_index = 0, -- Skip loading LuaLS completions as group index 0
    })
  end,
}
```

### Complete nvim-cmp Setup

```lua
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      sources = cmp.config.sources({
        { name = "lazydev" },     -- lazydev completions
        { name = "nvim_lsp" },    -- LSP completions
        { name = "luasnip" },     -- Snippet completions
        { name = "buffer" },      -- Buffer completions
        { name = "path" },        -- Path completions
      }),
      -- ... rest of your cmp configuration
    })
  end,
}
```

### blink.cmp Integration

```lua
{
  "saghen/blink.cmp",
  opts = {
    sources = {
      providers = {
        lazydev = {
          name = "lazydev",
          module = "lazydev.integrations.blink",
        },
      },
      completion = {
        enabled_providers = { "lazydev", "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
```

## Common Use Cases

### 1. Neovim Configuration Development
Perfect for editing your personal Neovim configuration with proper completion for:
- Neovim API functions
- Plugin configurations
- Lua standard library

### 2. Plugin Development
Essential for developing Neovim plugins with:
- Plugin API completion
- Dependency management
- Testing framework integration

### 3. Custom Module Development
Ideal for creating custom Lua modules with:
- Type checking
- Documentation generation
- Cross-module references

### 4. Multi-project Workflows
Excellent for working on multiple Neovim-related projects:
- Automatic library detection
- Project-specific configurations
- No manual setup required

## Configuration Options

### Library Specification
```lua
---@class lazydev.Library.spec
{
  path = "string",              -- Library path (required)
  words = { "pattern1", ... },  -- Trigger words (optional)
  mods = { "module1", ... },    -- Required modules (optional)
  files = { "file1.lua", ... }, -- Specific files (optional)
}
```

### Path Formats
- **Absolute**: `/full/path/to/library`
- **Relative**: `./relative/path`
- **Plugin**: `plugin-name` (automatically resolved)
- **Third-party**: `${3rd}/library-name/library`

### Trigger Patterns
- **Lua Patterns**: Use Lua pattern matching
- **Examples**: `"vim%.uv"`, `"telescope"`, `"neotest"`
- **Case Sensitive**: Patterns are case-sensitive

## Commands

### `:LazyDev`
Shows current buffer's lazydev settings in a notification.

### `:LazyDev lsp`
Displays settings for attached LSP servers.

### `:LazyDev debug`
Provides detailed debugging information for troubleshooting.

## Related Plugins and Alternatives

### Replaced Plugins
- **neodev.nvim**: Deprecated in favor of lazydev.nvim
- **lua-dev.nvim**: Older alternative with similar functionality

### Complementary Plugins
- **mason.nvim**: LSP server management
- **nvim-lspconfig**: LSP configuration
- **nvim-cmp**: Completion engine
- **LuaSnip**: Snippet engine

### Alternative Approaches
- **Manual LuaLS setup**: More control but requires extensive configuration
- **IDE-specific solutions**: For users preferring full IDEs over Neovim

## Migration from neodev.nvim

### Key Differences
1. **Performance**: lazydev.nvim is significantly faster
2. **Configuration**: Simpler setup with less manual configuration
3. **Loading Strategy**: Lazy loading vs. upfront loading
4. **Maintenance**: Active development vs. deprecated

### Migration Steps
1. Remove `neodev.nvim` from your configuration
2. Add `lazydev.nvim` with basic configuration
3. Update completion engine integration
4. Test and adjust library specifications as needed

### Example Migration
```lua
-- Old neodev.nvim configuration
{
  "folke/neodev.nvim",
  opts = {
    library = {
      enabled = true,
      runtime = true,
      types = true,
      plugins = { "nvim-treesitter", "plenary.nvim" },
    },
  },
}

-- New lazydev.nvim configuration
{
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      "nvim-treesitter",
      "plenary.nvim",
    },
  },
}
```

## Troubleshooting

### Common Issues

1. **Completions Not Working**
   - Ensure LuaLS is properly installed and configured
   - Check that the library paths are correct
   - Verify trigger words match your code usage

2. **Performance Issues**
   - Review library specifications for unnecessary libraries
   - Use conditional loading with trigger words
   - Check for conflicting LSP configurations

3. **Missing Types**
   - Add specific library paths for missing types
   - Use `:LazyDev debug` to inspect current configuration
   - Ensure required modules are properly specified

### Debug Commands
```lua
-- Check current configuration
:LazyDev

-- Inspect LSP settings
:LazyDev lsp

-- Detailed debugging
:LazyDev debug
```

## Best Practices

1. **Use Conditional Loading**: Specify trigger words to avoid loading unnecessary libraries
2. **Organize Libraries**: Group related libraries together in configuration
3. **Test Performance**: Monitor completion speed and adjust configuration as needed
4. **Keep Updated**: Regularly update the plugin for latest improvements
5. **Minimal Configuration**: Start with basic setup and add libraries as needed

## Resources

- **GitHub Repository**: [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim)
- **Documentation**: Available in the repository README
- **Community**: Neovim community discussions and plugin forums
- **Issues**: Report bugs and feature requests on GitHub