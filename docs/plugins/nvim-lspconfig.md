# nvim-lspconfig

A collection of configurations for Neovim's built-in Language Server Protocol (LSP) client that simplifies the process of setting up language servers.

## Plugin Overview and Purpose

**nvim-lspconfig** is the de facto standard plugin for configuring language servers in Neovim. It provides predefined configurations for 300+ language servers, making it easy to enable LSP features like autocompletion, go-to-definition, diagnostics, and more across different programming languages.

### What it Does
- Provides pre-configured setups for popular language servers
- Handles root directory detection for workspaces
- Manages server startup commands and filetypes
- Integrates seamlessly with Neovim's built-in LSP client
- Offers standardized configuration patterns

### What it Doesn't Do
- Install language servers (use Mason for that)
- Provide completion UI (use completion plugins like blink.cmp)
- Handle formatting (use conform.nvim or similar)

## Key Features and Capabilities

### Predefined Configurations
- **300+ language server configs**: Ready-to-use configurations for most popular languages
- **Automatic filetype detection**: Servers attach automatically based on file types
- **Root directory detection**: Smart workspace detection using markers like `.git/`, `package.json`, etc.
- **Standardized settings**: Consistent configuration patterns across all servers

### LSP Features Enabled
- **Go to definition/declaration/implementation**
- **Find references**
- **Symbol search and navigation**
- **Real-time diagnostics and error reporting**
- **Code actions and quick fixes**
- **Hover documentation**
- **Signature help**
- **Workspace symbols**
- **Renaming across files**

### Modern Architecture (Neovim 0.11+)
With Neovim 0.11+, nvim-lspconfig has evolved to work with built-in functions:
- Uses `vim.lsp.enable()` instead of traditional setup
- Serves primarily as a configuration data repository
- Leverages `vim.lsp.config()` for customization

## Installation and Configuration

### Requirements
- Neovim 0.11.3+ (support for 0.10 will be removed)
- Language servers must be installed separately

### Basic Configuration (Neovim 0.11+)
```lua
-- Enable language servers
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('ts_ls')
```

### Traditional Configuration (Pre-0.11)
```lua
local lspconfig = require('lspconfig')

-- Basic server setup
lspconfig.lua_ls.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.ts_ls.setup({})
```

## LSP Server Setup Examples

### Lua Language Server (lua_ls)
```lua
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' }, -- Recognize 'vim' global
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      completion = {
        callSnippet = 'Replace',
      },
    },
  },
})
```

### Python (pyright)
```lua
vim.lsp.config('pyright', {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})
```

### TypeScript (ts_ls)
```lua
vim.lsp.config('ts_ls', {
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
})
```

### Rust (rust_analyzer)
```lua
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = 'clippy',
      },
    },
  },
})
```

### Custom Server Path
```lua
vim.lsp.config('jdtls', {
  cmd = { '/path/to/jdtls' },
  filetypes = { 'java' },
  root_markers = { 'build.gradle', 'pom.xml', '.git' },
})
```

## Configuration Options and Customization

### Core Configuration Options
```lua
vim.lsp.config('server_name', {
  cmd = { 'language-server-command' },     -- Command to start server
  filetypes = { 'filetype1', 'filetype2' }, -- Supported file types
  root_markers = { '.git', 'package.json' }, -- Workspace detection
  settings = {},                           -- Server-specific settings
  capabilities = {},                       -- LSP capabilities
  on_attach = function(client, bufnr) end, -- Callback when server attaches
  init_options = {},                       -- Initialization options
  single_file_support = true,             -- Support for single files
})
```

### Advanced Customization
```lua
-- Custom on_attach function
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
end
```

### Capabilities Integration
```lua
-- With blink.cmp
local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  -- other options...
})
```

## Integration with Completion and Other Tools

### Mason Integration
```lua
{
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
  },
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls', 'rust_analyzer', 'pyright' },
      automatic_installation = true,
    })

    -- Auto-setup installed servers
    require('mason-lspconfig').setup_handlers({
      function(server_name)
        vim.lsp.enable(server_name)
      end,
    })
  end,
}
```

### Completion Integration
```lua
-- With blink.cmp
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Apply to all servers
local default_setup = function(server_name)
  vim.lsp.config(server_name, {
    capabilities = capabilities,
  })
end
```

### Telescope Integration
```lua
-- LSP-related telescope pickers
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references)
vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions)
vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations)
vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_workspace_symbols)
```

## Common Use Cases and Workflows

### 1. Basic Development Setup
```lua
-- Install and configure essential servers
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',     -- Lua
    'pyright',    -- Python
    'ts_ls',      -- TypeScript/JavaScript
    'rust_analyzer', -- Rust
    'clangd',     -- C/C++
  }
})

-- Enable all installed servers
require('mason-lspconfig').setup_handlers({
  function(server_name)
    vim.lsp.enable(server_name)
  end,
})
```

### 2. Language-Specific Workflows

#### Web Development
```lua
-- Frontend setup
vim.lsp.enable('ts_ls')      -- TypeScript
vim.lsp.enable('html')       -- HTML
vim.lsp.enable('cssls')      -- CSS
vim.lsp.enable('tailwindcss') -- Tailwind CSS
vim.lsp.enable('eslint')     -- ESLint
```

#### Systems Programming
```lua
-- Low-level development
vim.lsp.enable('clangd')        -- C/C++
vim.lsp.enable('rust_analyzer') -- Rust
vim.lsp.enable('zls')           -- Zig
```

#### Data Science
```lua
-- Python-focused setup
vim.lsp.enable('pyright')  -- Python type checking
vim.lsp.enable('ruff_lsp') -- Fast Python linter
```

### 3. Keybinding Setup
```lua
-- LSP keybindings on attach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    local opts = { buffer = args.buf }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)

    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Documentation
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  end,
})
```

## Troubleshooting and Debugging

### Health Check
```lua
-- Check LSP health
:checkhealth vim.lsp
```

### Common Issues and Solutions

#### 1. Server Not Starting
**Problem**: Language server doesn't start or attach

**Solutions**:
```lua
-- Check if server is installed
:!which lua-language-server

-- Check LSP info
:LspInfo

-- Enable logging
vim.lsp.set_log_level('debug')
:LspLog
```

#### 2. Wrong Root Directory
**Problem**: Server attaches to wrong workspace

**Solutions**:
```lua
-- Check current root
:lua print(vim.lsp.buf.list_workspace_folders()[1])

-- Custom root detection
vim.lsp.config('server_name', {
  root_markers = { 'custom-marker', '.git' },
  -- or explicit root
  root_dir = '/path/to/project',
})
```

#### 3. Capabilities Not Working
**Problem**: Completion or other features not working

**Solutions**:
```lua
-- Ensure capabilities are set
local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config('server_name', {
  capabilities = capabilities,
})

-- Check client capabilities
:lua print(vim.inspect(vim.lsp.get_active_clients()[1].server_capabilities))
```

#### 4. Multiple Servers Conflict
**Problem**: Multiple servers providing same functionality

**Solutions**:
```lua
-- Disable specific capabilities
vim.lsp.config('ts_ls', {
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})
```

### Debugging Commands
```lua
-- View server status
:LspInfo

-- View logs
:LspLog

-- Restart server
:LspRestart

-- Show attached clients
:lua print(vim.inspect(vim.lsp.get_active_clients()))

-- Check server capabilities
:lua print(vim.inspect(vim.lsp.get_active_clients()[1].server_capabilities))
```

## Related Plugins and Alternatives

### Essential Companions
- **mason.nvim**: LSP server installer and manager
- **mason-lspconfig.nvim**: Bridge between Mason and lspconfig
- **blink.cmp**: Modern completion engine with LSP integration
- **telescope.nvim**: Fuzzy finder with LSP pickers
- **conform.nvim**: Code formatting
- **fidget.nvim**: LSP progress notifications

### Alternative Approaches
- **lsp-zero.nvim**: Simplified LSP setup with sensible defaults
- **typescript-tools.nvim**: TypeScript-specific LSP plugin
- **rustaceanvim**: Rust-specific LSP enhancements
- **java-language-server**: Java-specific setup

### Completion Alternatives
- **nvim-cmp**: Traditional completion engine
- **coq_nvim**: Fast completion with unique features
- **ddc.vim**: Vim-style completion framework

### Language-Specific Plugins
```lua
-- Enhanced language support
{
  'mrcjkb/rustaceanvim',      -- Rust
  'pmizio/typescript-tools.nvim', -- TypeScript
  'mfussenegger/nvim-jdtls',  -- Java
  'akinsho/flutter-tools.nvim', -- Flutter/Dart
}
```

## Best Practices

### 1. Modular Configuration
```lua
-- Separate LSP config into modules
require('config.lsp.servers')
require('config.lsp.keymaps')
require('config.lsp.diagnostics')
```

### 2. Conditional Setup
```lua
-- Only enable if server is available
if vim.fn.executable('rust-analyzer') == 1 then
  vim.lsp.enable('rust_analyzer')
end
```

### 3. Project-Specific Configuration
```lua
-- Use .nvim.lua for project-specific LSP settings
-- In project root: .nvim.lua
vim.lsp.config('custom_server', {
  cmd = { './scripts/language-server' },
  root_markers = { 'project.toml' },
})
```

This comprehensive setup provides a robust foundation for LSP integration in Neovim, enabling powerful language features across your development workflow.