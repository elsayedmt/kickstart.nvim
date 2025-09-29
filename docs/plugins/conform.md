# conform.nvim

A lightweight yet powerful formatter plugin for Neovim that provides a simple and flexible way to integrate code formatters into your workflow.

## Plugin Overview and Purpose

conform.nvim is designed to be a modern replacement for null-ls formatting capabilities, focusing specifically on code formatting. It provides a clean API similar to `vim.lsp.buf.format()` while offering superior functionality and performance. The plugin preserves editor state (extmarks, folds, cursor position) during formatting operations and enables range formatting for all formatters.

**Key Benefits:**
- Lightweight and focused on formatting only
- Preserves extmarks and folds during formatting
- Fixes problematic LSP formatters
- Enables range formatting for all formatters
- Can format embedded code blocks in markdown
- Simple, intuitive API design

## Key Features and Capabilities

### Core Features
- **Format on Save**: Automatic formatting when saving files with configurable timeout
- **Manual Formatting**: Format entire buffer or selected ranges with keybindings
- **LSP Integration**: Seamless integration with LSP formatters as fallback or primary
- **Range Formatting**: Format only selected text in visual mode
- **Embedded Code Support**: Format code blocks within markdown files
- **Async Operations**: Non-blocking formatting operations
- **Diff-based Updates**: Only modifies changed lines to preserve editor state

### Advanced Capabilities
- **Multiple Formatters**: Run multiple formatters sequentially per filetype
- **Conditional Formatting**: Disable formatting for specific filetypes or buffers
- **Custom Formatters**: Define your own formatters with Lua functions
- **Formatter Discovery**: Automatic detection of available formatters
- **Logging and Debugging**: Comprehensive logging for troubleshooting

## Requirements

- **Neovim**: Version 0.10+ (for older versions, use nvim-0.x branches)
- **External Formatters**: Install the specific formatters you want to use (e.g., stylua, prettier, black)

## Installation and Configuration

### Installation

#### Using lazy.nvim
```lua
{
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    -- Configuration goes here
  },
}
```

#### Using packer.nvim
```lua
use({
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup({
      -- Configuration
    })
  end,
})
```

#### Using vim-plug
```vim
Plug 'stevearc/conform.nvim'
```

### Basic Configuration

```lua
require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    javascript = { 'prettierd', 'prettier' },
    typescript = { 'prettierd', 'prettier' },
    rust = { 'rustfmt' },
    go = { 'goimports', 'gofmt' },
    css = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
  },
})
```

## Formatter Setup and Configuration

### Formatters by Filetype

The `formatters_by_ft` table defines which formatters to use for each filetype:

```lua
formatters_by_ft = {
  -- Single formatter
  lua = { 'stylua' },

  -- Multiple formatters (run sequentially)
  python = { 'isort', 'black' },

  -- Fallback to LSP formatting
  rust = { 'rustfmt', lsp_format = 'fallback' },

  -- Stop after first successful formatter
  javascript = { 'prettierd', 'prettier', stop_after_first = true },

  -- Use LSP as primary, fallback to external
  typescript = { lsp_format = 'prefer', 'prettier' },

  -- Format all filetypes with a specific formatter
  ['*'] = { 'codespell' },

  -- Use specific formatter for files without detected filetype
  ['_'] = { 'trim_whitespace' },
}
```

### Custom Formatter Configuration

Override built-in formatter settings or add custom formatters:

```lua
require('conform').setup({
  formatters = {
    -- Override built-in formatter
    stylua = {
      prepend_args = { '--indent-type', 'Spaces', '--indent-width', '2' },
    },

    -- Custom formatter
    my_formatter = {
      command = 'my_cmd',
      args = { '--stdin-from-filename', '$FILENAME' },
      range_args = function(self, ctx)
        return { '--line-start', ctx.range.start[1], '--line-end', ctx.range['end'][1] }
      end,
      stdin = true,
      cwd = require('conform.util').root_file({ '.editorconfig', 'package.json' }),
      env = {
        VAR = 'value',
      },
    },

    -- Lua function formatter
    lua_format = {
      format = function(self, ctx, lines, callback)
        -- Custom formatting logic
        local formatted_lines = {}
        for _, line in ipairs(lines) do
          table.insert(formatted_lines, line:gsub('%s+$', '')) -- Remove trailing whitespace
        end
        callback(nil, formatted_lines)
      end,
    },
  },
})
```

## Format on Save Configuration

### Basic Format on Save

```lua
require('conform').setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
})
```

### Conditional Format on Save

```lua
require('conform').setup({
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return nil
    end

    -- Disable for specific filetypes
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    end

    -- Only enable for specific filetypes
    local enable_filetypes = { lua = true, python = true }
    if not enable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    end

    return {
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end,
})
```

### Advanced Format on Save Options

```lua
require('conform').setup({
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = 'fallback',
    async = false,
    quiet = false,
  },
})
```

## Usage Examples and Commands

### Manual Formatting

```lua
-- Format entire buffer
require('conform').format({ async = true, lsp_format = 'fallback' })

-- Format with timeout
require('conform').format({ timeout_ms = 1000 })

-- Format selection in visual mode
require('conform').format({ range = true })

-- Format with specific formatters
require('conform').format({ formatters = { 'stylua' } })
```

### Keybindings

```lua
vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
  require('conform').format({
    lsp_format = 'fallback',
    async = false,
    timeout_ms = 500,
  })
end, { desc = 'Format file or range (in visual mode)' })

-- Format on save toggle
vim.keymap.set('n', '<leader>tf', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  print('Autoformat ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))
end, { desc = 'Toggle format on save' })
```

### Commands

```vim
" View configured formatters and log file
:ConformInfo

" Format current buffer
:lua require('conform').format()

" Format with specific formatter
:lua require('conform').format({ formatters = { 'prettier' } })
```

### formatexpr Integration

Set up `formatexpr` for integrated formatting with `gq`:

```lua
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
```

## Integration with LSP

### LSP Format Options

```lua
formatters_by_ft = {
  -- Use LSP as primary formatter
  typescript = { lsp_format = 'prefer' },

  -- Use LSP as fallback
  lua = { 'stylua', lsp_format = 'fallback' },

  -- Disable LSP formatting
  python = { 'black', lsp_format = 'never' },

  -- LSP only
  rust = { lsp_format = 'prefer' },
}
```

### LSP and External Formatter Combination

```lua
-- Use external formatter first, fallback to LSP
require('conform').format({
  formatters = { 'prettier' },
  lsp_format = 'fallback',
})

-- Prefer LSP, use external as fallback
require('conform').format({
  lsp_format = 'prefer',
  formatters = { 'prettier' },
})
```

## Configuration Options

### Complete Configuration Example

```lua
require('conform').setup({
  -- Map of filetype to formatters
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
  },

  -- Format on save configuration
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },

  -- Custom formatters and overrides
  formatters = {
    stylua = {
      prepend_args = { '--indent-type', 'Spaces' },
    },
  },

  -- Logging level
  log_level = vim.log.levels.ERROR,

  -- Notification settings
  notify_on_error = true,
  notify_no_formatters = true,

  -- Default format options
  default_format_opts = {
    lsp_format = 'fallback',
  },
})
```

### Available Options

| Option | Type | Description |
|--------|------|-------------|
| `formatters_by_ft` | table | Map of filetype to formatters |
| `formatters` | table | Custom formatter configurations |
| `format_on_save` | table\|function | Format on save configuration |
| `default_format_opts` | table | Default options for format() |
| `log_level` | number | Logging level (vim.log.levels.*) |
| `notify_on_error` | boolean | Show notifications on errors |
| `notify_no_formatters` | boolean | Notify when no formatters available |

## Common Use Cases

### 1. Web Development Setup

```lua
formatters_by_ft = {
  javascript = { 'prettierd', 'prettier', stop_after_first = true },
  typescript = { 'prettierd', 'prettier', stop_after_first = true },
  javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
  typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
  vue = { 'prettier' },
  css = { 'prettier' },
  scss = { 'prettier' },
  less = { 'prettier' },
  html = { 'prettier' },
  json = { 'prettier' },
  jsonc = { 'prettier' },
  yaml = { 'prettier' },
  markdown = { 'prettier' },
  graphql = { 'prettier' },
}
```

### 2. Python Development

```lua
formatters_by_ft = {
  python = { 'isort', 'black' },
},
formatters = {
  black = {
    prepend_args = { '--line-length', '88', '--fast' },
  },
  isort = {
    prepend_args = { '--profile', 'black' },
  },
}
```

### 3. Multi-language Project

```lua
formatters_by_ft = {
  lua = { 'stylua' },
  python = { 'isort', 'black' },
  rust = { 'rustfmt' },
  go = { 'goimports', 'gofmt' },
  javascript = { 'prettier' },
  typescript = { 'prettier' },
  css = { 'prettier' },
  html = { 'prettier' },
  json = { 'prettier' },
  yaml = { 'prettier' },
  markdown = { 'prettier' },
  sh = { 'shfmt' },
  ['*'] = { 'codespell' },
  ['_'] = { 'trim_whitespace' },
}
```

### 4. Conditional Formatting

```lua
format_on_save = function(bufnr)
  -- Skip formatting for large files
  if vim.api.nvim_buf_line_count(bufnr) > 1000 then
    return nil
  end

  -- Only format files in certain directories
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname:match('/node_modules/') or bufname:match('/vendor/') then
    return nil
  end

  return { timeout_ms = 500, lsp_format = 'fallback' }
end
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Formatter Not Found
```bash
# Check if formatter is installed
which prettier
which stylua
which black

# Install missing formatters
npm install -g prettier
cargo install stylua
pip install black
```

#### 2. Path Issues
```lua
-- Check Neovim's PATH
:lua print(vim.env.PATH)

-- Add to PATH in init.lua
vim.env.PATH = vim.env.PATH .. ':/usr/local/bin'
```

#### 3. Debugging Formatters
```vim
" View formatter info and logs
:ConformInfo

" Enable debug logging
:lua require('conform').setup({ log_level = vim.log.levels.DEBUG })
```

#### 4. Format on Save Not Working
```lua
-- Check if format_on_save is configured
:lua print(vim.inspect(require('conform.config').get_config().format_on_save))

-- Manually trigger format on save
:lua require('conform').format({ timeout_ms = 500, lsp_format = 'fallback' })
```

#### 5. Formatter Errors
```lua
-- Enable error notifications
require('conform').setup({
  notify_on_error = true,
  log_level = vim.log.levels.ERROR,
})
```

### Debugging Tips

1. **Use `:ConformInfo`** to view:
   - Configured formatters for current buffer
   - Available formatters on system
   - Log file location

2. **Check formatter availability**:
   ```lua
   :lua print(vim.inspect(require('conform').get_formatter_info('prettier')))
   ```

3. **Test formatter manually**:
   ```bash
   echo "console.log('test')" | prettier --stdin-filepath test.js
   ```

4. **View logs**:
   ```bash
   tail -f ~/.local/state/nvim/conform.log
   ```

## Related Plugins and Alternatives

### Complementary Plugins
- **mason.nvim**: Install and manage formatters
- **mason-conform.nvim**: Automatically install conform formatters via Mason
- **which-key.nvim**: Discoverable keybindings for formatting commands
- **telescope.nvim**: Find and run specific formatters

### Alternative Plugins
- **null-ls.nvim**: More comprehensive but heavier (archived)
- **formatter.nvim**: Similar functionality, different API
- **neoformat**: Older formatting plugin
- **LSP built-in formatting**: Limited to LSP-supported formatters

### Migration from null-ls

If migrating from null-ls, conform.nvim provides a smoother experience:

```lua
-- null-ls style (old)
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
  },
})

-- conform.nvim style (new)
require('conform').setup({
  formatters_by_ft = {
    javascript = { 'prettier' },
    lua = { 'stylua' },
  },
})
```

### Advantages over Alternatives

1. **Performance**: Faster startup and formatting operations
2. **Reliability**: Better handling of edge cases and errors
3. **Simplicity**: Focused API without unnecessary complexity
4. **Maintenance**: Actively maintained with regular updates
5. **Integration**: Better LSP integration and fallback handling

---

*For the most up-to-date information and complete list of supported formatters, run `:help conform-formatters` in Neovim or visit the [official repository](https://github.com/stevearc/conform.nvim).*