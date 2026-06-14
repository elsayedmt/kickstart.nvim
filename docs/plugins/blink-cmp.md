# blink.cmp

A performant, batteries-included completion plugin for Neovim with LSP, snippets, and signature help support built-in.

## Plugin Overview and Purpose

blink.cmp is a modern completion engine designed for speed and simplicity. It processes completion updates on every keystroke with minimal latency (0.5-4ms async) and includes features like typo-resistant fuzzy matching, semantic token-based auto-bracket insertion, and native snippet support. The plugin works out of the box with sensible defaults while offering extensive customization options.

**Key Benefits:**
- Extremely fast performance (0.5-4ms per keystroke)
- Works immediately without additional configuration
- Built-in LSP, snippet, cmdline, and signature help support
- Typo-resistant fuzzy matching via "frizbee" (Rust-based, ~6x faster than fzf)
- Semantic token-based auto-bracket insertion
- Native integration with multiple snippet engines

## Key Features and Capabilities

### Core Features
- **Auto-completion**: Context-aware completions from LSP, snippets, paths, and custom sources
- **Fuzzy Matching**: Rust-based SIMD fuzzy matcher with typo tolerance, frecency, and proximity bonuses
- **Multi-mode Support**: Regular insert mode, command-line, and terminal completion
- **Signature Help**: Real-time function signature display while typing (experimental)
- **Ghost Text**: Inline completion previews
- **Auto-bracket**: Intelligent bracket insertion based on semantic tokens
- **Documentation Window**: Automatic or manual display of completion item documentation

### Advanced Capabilities
- **Multiple Snippet Engines**: Support for vim.snippet, LuaSnip, mini.snippets, and more
- **Custom Sources**: Compatibility layer for nvim-cmp sources via blink.compat
- **Dynamic Configuration**: Context-aware settings (e.g., disable preselect in snippets)
- **Component-based Rendering**: Customizable UI components
- **Performance Optimizations**: Async operations with minimal overhead

## Requirements

- **Neovim**: Version 0.10+ (0.11+ for terminal completion)
- **Optional**: Rust toolchain for building fuzzy matcher from source (prebuilt binaries available)
- **Optional**: Snippet engine (LuaSnip, vim.snippet, or mini.snippets)

## Installation and Configuration

### Installation

### Basic Configuration

```lua
require('blink.cmp').setup({
  keymap = {
    preset = 'default',  -- 'default', 'super-tab', 'enter', or 'none'
  },

  appearance = {
    nerd_font_variant = 'mono',  -- 'mono' or 'normal'
  },

  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    ghost_text = { enabled = true },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  fuzzy = {
    implementation = 'prefer_rust_with_warning',  -- or 'lua'
  },

  signature = { enabled = true },
})
```

## Keymap Presets

### Available Presets

#### `default` (Recommended)
Traditional Vim-style completion keybindings:
- `<C-y>`: Accept completion
- `<C-space>`: Show/toggle documentation
- `<C-e>`: Hide menu
- `<C-n>`/`<C-p>` or `<Up>`/`<Down>`: Navigate items
- `<C-b>`/`<C-f>`: Scroll documentation
- `<Tab>`/`<S-Tab>`: Jump between snippet placeholders
- `<C-k>`: Toggle signature help

#### `super-tab`
Tab-centric workflow (set `completion.trigger.show_in_snippet = false`):
- `<Tab>`: Accept completion or jump to next snippet placeholder
- All other default bindings preserved

#### `enter`
Enter-key acceptance (set `completion.list.selection.preselect = false`):
- `<CR>`: Accept completion
- All other default bindings preserved

#### `none`
Disables all presets for fully custom keymaps

### Custom Keymaps

```lua
keymap = {
  preset = 'default',
  ['<C-l>'] = { 'select_and_accept' },
  ['<C-k>'] = { 'show_documentation', 'hide_documentation' },
  ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
  ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
}
```

## Fuzzy Matching Configuration

### Implementation Options

blink.cmp uses **frizbee**, a custom SIMD fuzzy matcher that's ~6x faster than fzf:

```lua
fuzzy = {
  implementation = 'prefer_rust_with_warning',  -- Recommended
  -- Options: 'prefer_rust_with_warning', 'prefer_rust', 'rust', 'lua'
}
```

### Rust vs Lua

**Rust Implementation (Recommended):**
- ~6x performance improvement
- Full Unicode support
- Better match quality and sorting
- Handles 10,000+ item lists efficiently
- Built-in typo tolerance, proximity bonuses, frecency scoring
- Prebuilt binaries auto-downloaded on supported systems

**Lua Implementation:**
- Pure Lua fallback
- Works everywhere
- Slower with large completion lists

## Sources Configuration

### Default Sources

```lua
sources = {
  default = { 'lsp', 'path', 'snippets' },
  providers = {
    -- Custom provider configuration
    lsp = {
      score_offset = 0,  -- Adjust ranking priority
    },
  },
}
```

### Adding Custom Sources

```lua
sources = {
  default = { 'lsp', 'path', 'snippets', 'buffer' },
  providers = {
    -- Add custom providers here
  },
}
```

### nvim-cmp Source Compatibility

```lua
dependencies = { 'saghen/blink.compat' },
sources = {
  default = { 'lsp', 'path', 'snippets', 'my_cmp_source' },
  providers = {
    my_cmp_source = {
      module = 'blink.compat.source',
      opts = {
        source = 'my_cmp_source',  -- nvim-cmp source name
      },
    },
  },
}
```

## Completion Behavior

### Documentation Auto-Show

```lua
completion = {
  documentation = {
    auto_show = true,           -- Show docs automatically
    auto_show_delay_ms = 500,   -- Delay before showing
    treesitter_highlighting = true,  -- Syntax highlighting in docs
  },
}
```

### Ghost Text

```lua
completion = {
  ghost_text = {
    enabled = true,  -- Inline completion preview
  },
}
```

### List Behavior

```lua
completion = {
  list = {
    selection = {
      preselect = true,      -- Auto-select first item
      auto_insert = true,    -- Auto-insert on select
    },
  },
  trigger = {
    show_on_keyword = true,  -- Show after typing keywords
  },
}
```

### Dynamic Configuration

```lua
completion = {
  list = {
    selection = {
      preselect = function(ctx)
        -- Disable preselect in snippets or specific filetypes
        return ctx.mode ~= 'snippet' and vim.bo.filetype ~= 'markdown'
      end,
    },
  },
}
```

## Snippet Integration

### LuaSnip

```lua
dependencies = {
  {
    'L3MON4D3/LuaSnip',
    version = '2.*',
    build = 'make install_jsregexp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },
},
snippets = { preset = 'luasnip' },
```

### vim.snippet (Neovim 0.10+)

```lua
snippets = { preset = 'vim-snippet' },
```

### mini.snippets

```lua
dependencies = { 'echasnovski/mini.snippets' },
snippets = { preset = 'mini-snippets' },
```

## Usage Examples and Commands

### Programmatic Usage

```lua
-- Check if completion menu is visible
require('blink.cmp').is_visible()

-- Show completion menu
require('blink.cmp').show()

-- Hide completion menu
require('blink.cmp').hide()

-- Accept selected item
require('blink.cmp').accept()

-- Navigate items
require('blink.cmp').select_next()
require('blink.cmp').select_prev()

-- Scroll documentation
require('blink.cmp').scroll_documentation_up(4)
require('blink.cmp').scroll_documentation_down(4)
```

### Checking Configuration

```vim
" Get LSP capabilities advertised by blink.cmp
:lua print(vim.inspect(require('blink.cmp').get_lsp_capabilities()))

" Check formatter info
:lua print(vim.inspect(require('blink.cmp').get_config()))
```

## Common Use Cases

### 1. Minimal Setup

```lua
{
  'saghen/blink.cmp',
  version = '1.*',
  opts = {},  -- Use all defaults
}
```

### 2. Tab Completion

```lua
{
  'saghen/blink.cmp',
  version = '1.*',
  opts = {
    keymap = { preset = 'super-tab' },
    completion = {
      trigger = { show_in_snippet = false },
    },
  },
}
```

### 3. Enter to Accept

```lua
{
  'saghen/blink.cmp',
  version = '1.*',
  opts = {
    keymap = { preset = 'enter' },
    completion = {
      list = { selection = { preselect = false } },
    },
  },
}
```

### 4. Performance-Focused

```lua
{
  'saghen/blink.cmp',
  version = '1.*',
  opts = {
    fuzzy = { implementation = 'rust' },  -- Force Rust
    completion = {
      documentation = {
        auto_show = false,  -- Manual trigger only
        treesitter_highlighting = false,  -- Disable for performance
      },
    },
  },
}
```

### 5. Feature-Rich Setup

```lua
{
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
  },
  opts = {
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      ghost_text = { enabled = true },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    snippets = { preset = 'luasnip' },
    signature = { enabled = true },
  },
}
```

## Troubleshooting

### Common Issues

#### 1. Completions Not Showing

**Check LSP attachment:**
```vim
:LspInfo
```

**Verify blink.cmp is loaded:**
```lua
:lua print(require('blink.cmp').is_available())
```

**Check sources configuration:**
```lua
:lua print(vim.inspect(require('blink.cmp').get_config().sources))
```

#### 2. Rust Fuzzy Matcher Not Working

**Check if Rust binary was downloaded:**
```bash
ls ~/.local/share/nvim/blink.cmp/
```

**Force Lua fallback:**
```lua
fuzzy = { implementation = 'lua' }
```

**Build from source (requires nightly Rust):**
```bash
cd <path-to-blink.cmp>
cargo build --release
```

#### 3. Snippets Not Expanding

**Check snippet configuration:**
```lua
:lua print(require('blink.cmp').get_config().snippets.preset)
```

**Test snippet engine directly:**
```lua
:lua require('luasnip').expand_or_jump()
```

#### 4. Documentation Not Showing

**Check auto_show setting:**
```lua
:lua print(require('blink.cmp').get_config().completion.documentation.auto_show)
```

**Manually trigger:**
Press `<C-space>` with item selected

**Disable treesitter highlighting if slow:**
```lua
completion = {
  documentation = {
    treesitter_highlighting = false,
  },
}
```

#### 5. Performance Issues

**Disable expensive features:**
```lua
completion = {
  documentation = {
    auto_show = false,
    treesitter_highlighting = false,
  },
  ghost_text = { enabled = false },
}
```

**Use Rust fuzzy matcher:**
```lua
fuzzy = { implementation = 'rust' }
```

## Related Plugins and Alternatives

### Complementary Plugins
- **LuaSnip**: Snippet engine with advanced features
- **friendly-snippets**: Collection of pre-made snippets
- **mason.nvim**: LSP server management
- **nvim-lspconfig**: LSP configuration

### Alternative Completion Plugins
- **nvim-cmp**: Most popular, large ecosystem, slower
- **coq_nvim**: Fast, SQLite-based, complex
- **mini.completion**: Minimal, part of mini.nvim
- **cmp-copilot**: AI-powered completions (can work alongside blink.cmp)

### Migration from nvim-cmp

blink.cmp is designed as a faster, more modern alternative:

```lua
-- nvim-cmp style (old)
require('cmp').setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

-- blink.cmp style (new)
require('blink.cmp').setup({
  sources = {
    default = { 'lsp', 'buffer', 'path' },
  },
})
```

### Advantages over Alternatives

1. **Performance**: 0.5-4ms latency vs 10-50ms for nvim-cmp
2. **Batteries Included**: LSP, snippets, cmdline, signature help built-in
3. **Modern Design**: Semantic tokens, better fuzzy matching
4. **Simplicity**: Works out of the box with minimal configuration
5. **Active Development**: Regular updates and improvements

---

*For the most up-to-date information, visit the [official documentation](https://cmp.saghen.dev) or [GitHub repository](https://github.com/saghen/blink.cmp).*
