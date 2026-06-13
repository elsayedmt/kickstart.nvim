# friendly-snippets

A collection of pre-configured snippets for various programming languages and frameworks, providing instant productivity boosts through commonly-used code patterns.

## Plugin Overview and Purpose

friendly-snippets is a community-driven repository containing hundreds of VSCode-style snippets for multiple languages and frameworks. These snippets work with any snippet engine that supports the VSCode snippet format (LuaSnip, vim-vsnip, coc-snippets, etc.). The collection includes snippets for common patterns like loops, conditionals, function definitions, imports, and framework-specific boilerplate.

**Key Benefits:**
- Hundreds of pre-made snippets across 50+ languages
- Framework-specific snippets (React, Vue, Django, etc.)
- Consistent snippet format across all editors
- Community-maintained and regularly updated
- Zero configuration required with compatible snippet engines

## Key Features and Capabilities

### Language Coverage

**Web Development:**
- JavaScript/TypeScript
- React/Vue/Svelte/Angular
- HTML/CSS/SCSS
- Node.js/Express

**Backend Languages:**
- Python (including Django, Flask)
- Go
- Rust
- Java/Kotlin
- C/C++
- C#
- PHP

**Scripting & Shell:**
- Lua
- Bash/Shell
- PowerShell
- Ruby

**Data & Config:**
- SQL
- JSON/YAML/TOML
- Markdown
- LaTeX

**Other:**
- Docker
- Git
- CMake
- And many more...

### Snippet Categories

**Common Patterns:**
- Variable declarations
- Function/method definitions
- Class structures
- Loops (for, while, foreach)
- Conditionals (if, switch, ternary)
- Error handling (try/catch)
- Comments and documentation

**Framework-Specific:**
- React: components, hooks, props
- Vue: directives, components, lifecycle
- Python: list comprehensions, context managers
- Go: error handling, struct tags
- Rust: match statements, impl blocks

## Requirements

- **Neovim**: Any version supporting your chosen snippet engine
- **Snippet Engine**: One of the following:
  - LuaSnip (recommended for Neovim)
  - vim-vsnip
  - coc-snippets
  - UltiSnips (with converter)

## Installation and Configuration

### Installation

#### Using lazy.nvim with LuaSnip

```lua
{
  'L3MON4D3/LuaSnip',
  dependencies = {
    'rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
```

#### Using lazy.nvim with blink.cmp

```lua
{
  'saghen/blink.cmp',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      dependencies = {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
  },
  opts = {
    snippets = { preset = 'luasnip' },
  },
}
```

#### Using packer.nvim

```lua
use {
  'L3MON4D3/LuaSnip',
  requires = { 'rafamadriz/friendly-snippets' },
  config = function()
    require('luasnip.loaders.from_vscode').lazy_load()
  end,
}
```

### Loading Specific Languages

Load only snippets for specific languages to reduce startup time:

```lua
-- Load all languages
require('luasnip.loaders.from_vscode').lazy_load()

-- Load specific languages only
require('luasnip.loaders.from_vscode').lazy_load({
  paths = { vim.fn.stdpath('data') .. '/lazy/friendly-snippets' },
  include = { 'python', 'javascript', 'typescript', 'rust' },
})

-- Exclude certain languages
require('luasnip.loaders.from_vscode').lazy_load({
  paths = { vim.fn.stdpath('data') .. '/lazy/friendly-snippets' },
  exclude = { 'tex', 'latex' },
})
```

### Loading Custom Snippet Directories

```lua
require('luasnip.loaders.from_vscode').lazy_load({
  paths = {
    vim.fn.stdpath('config') .. '/snippets',  -- Your custom snippets
    vim.fn.stdpath('data') .. '/lazy/friendly-snippets',  -- friendly-snippets
  },
})
```

## Common Snippet Examples

### JavaScript/TypeScript

| Trigger | Description |
|---------|-------------|
| `cl` | console.log() |
| `clg` | console.log() with variable |
| `fn` | Arrow function |
| `afn` | Async arrow function |
| `imp` | Import statement |
| `imd` | Import destructured |
| `exp` | Export default |
| `try` | Try/catch block |
| `for` | For loop |
| `fof` | For...of loop |
| `if` | If statement |
| `ife` | If...else |

### React

| Trigger | Description |
|---------|-------------|
| `rfc` | React functional component |
| `rfce` | React functional component with export |
| `rafce` | React arrow function component export |
| `rcc` | React class component |
| `use` | useState hook |
| `usee` | useEffect hook |
| `usef` | useEffect with dependencies |
| `usec` | useContext hook |
| `user` | useReducer hook |
| `usem` | useMemo hook |

### Python

| Trigger | Description |
|---------|-------------|
| `def` | Function definition |
| `deff` | Function with docstring |
| `class` | Class definition |
| `for` | For loop |
| `forin` | For...in loop |
| `if` | If statement |
| `elif` | Elif block |
| `try` | Try/except block |
| `with` | With statement (context manager) |
| `lambda` | Lambda function |
| `list` | List comprehension |
| `dict` | Dictionary comprehension |

### Go

| Trigger | Description |
|---------|-------------|
| `fn` | Function |
| `fmain` | Main function |
| `meth` | Method |
| `if` | If statement |
| `ife` | If err != nil |
| `for` | For loop |
| `forr` | For range loop |
| `st` | Struct |
| `in` | Interface |
| `switch` | Switch statement |
| `case` | Case clause |

### Rust

| Trigger | Description |
|---------|-------------|
| `fn` | Function |
| `pfn` | Public function |
| `afn` | Async function |
| `struct` | Struct definition |
| `enum` | Enum definition |
| `impl` | Implementation block |
| `trait` | Trait definition |
| `match` | Match expression |
| `if` | If statement |
| `for` | For loop |
| `while` | While loop |
| `macro` | Macro definition |

### Lua

| Trigger | Description |
|---------|-------------|
| `fn` | Function |
| `lfn` | Local function |
| `afn` | Anonymous function |
| `if` | If statement |
| `for` | For loop |
| `fori` | For ipairs loop |
| `forp` | For pairs loop |
| `while` | While loop |
| `req` | Require statement |
| `local` | Local variable |
| `table` | Table definition |

## Usage and Workflow

### Basic Workflow

1. **Type trigger word**: Start typing a snippet trigger (e.g., `fn`)
2. **Completion appears**: Your completion plugin shows the snippet
3. **Accept snippet**: Press your accept key (e.g., `<C-y>`, `<Tab>`, or `<CR>`)
4. **Fill placeholders**: Use `<Tab>` to jump between placeholders
5. **Complete snippet**: Press `<Tab>` on final placeholder to finish

### Example Session (JavaScript)

```javascript
// Type "afn" then accept
const fetchData = async () => {
  // Cursor here (first placeholder)
};

// Type "try" then accept
try {
  // Cursor here (first placeholder)
} catch (error) {
  // Second placeholder
}

// Type "imp" then accept
import  from '';
//     ^ first placeholder    ^ second placeholder
```

### Discovering Snippets

**Method 1: Completion menu**
- Start typing and browse suggestions
- Most completion plugins show snippet descriptions

**Method 2: Browse snippet files**
```bash
# View available snippets for a language
cat ~/.local/share/nvim/lazy/friendly-snippets/snippets/javascript.json

# List all available snippet files
ls ~/.local/share/nvim/lazy/friendly-snippets/snippets/
```

**Method 3: LuaSnip commands**
```vim
" Show available snippets for current filetype (with nvim-cmp or similar)
:CmpShowSnippets

" Or use Telescope if you have telescope-luasnip installed
:Telescope luasnip
```

## Customization

### Adding Custom Snippets

Create your own snippet files that load alongside friendly-snippets:

**Option 1: VSCode-style JSON**
```json
// ~/.config/nvim/snippets/javascript.json
{
  "Custom Log": {
    "prefix": "clog",
    "body": [
      "console.log('${1:label}:', $1);"
    ],
    "description": "Custom console.log with label"
  }
}
```

**Option 2: LuaSnip native format**
```lua
-- ~/.config/nvim/snippets/javascript.lua
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s('clog', {
    t("console.log('"),
    i(1, 'label'),
    t(":', "),
    i(2, 'value'),
    t(');'),
  }),
}
```

**Load custom snippets:**
```lua
-- In your config
require('luasnip.loaders.from_vscode').lazy_load({
  paths = { '~/.config/nvim/snippets' }
})

-- Or for Lua-format snippets
require('luasnip.loaders.from_lua').lazy_load({
  paths = { '~/.config/nvim/snippets' }
})
```

### Overriding Built-in Snippets

Create a file with the same name to override friendly-snippets:

```lua
-- ~/.config/nvim/snippets/python.json
-- This will override python snippets from friendly-snippets
{
  "def": {
    "prefix": "def",
    "body": [
      "def ${1:function_name}(${2:args}):",
      "    \"\"\"${3:docstring}\"\"\"",
      "    ${0:pass}"
    ]
  }
}
```

Load your custom snippets **after** friendly-snippets:
```lua
require('luasnip.loaders.from_vscode').lazy_load()  -- Load friendly-snippets first
require('luasnip.loaders.from_vscode').lazy_load({
  paths = { '~/.config/nvim/snippets' }  -- Override with custom
})
```

## Integration Examples

### With blink.cmp

```lua
{
  'saghen/blink.cmp',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      build = 'make install_jsregexp',
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
  },
  opts = {
    snippets = { preset = 'luasnip' },
    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },
  },
}
```

### With nvim-cmp

```lua
{
  'hrsh7th/nvim-cmp',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
      },
    })
  end,
}
```

### With vim-vsnip

```lua
{
  'hrsh7th/vim-vsnip',
  dependencies = { 'rafamadriz/friendly-snippets' },
}
```

## Troubleshooting

### Snippets Not Showing

**Check if snippets are loaded:**
```lua
:lua print(vim.inspect(require('luasnip').available()))
```

**Verify friendly-snippets is installed:**
```vim
:Lazy
```

**Check loader was called:**
```lua
-- Add to your config to debug
require('luasnip.loaders.from_vscode').lazy_load()
print('Snippets loaded!')
```

### Wrong Snippets for Filetype

**Check current filetype:**
```vim
:set filetype?
```

**Reload snippets for current filetype:**
```lua
:lua require('luasnip.loaders').reload_current_filetype()
```

### Snippets Not Expanding

**Check snippet engine keybindings:**
```lua
-- Ensure you have expansion keybinding
vim.keymap.set('i', '<Tab>', function()
  if require('luasnip').expand_or_jumpable() then
    require('luasnip').expand_or_jump()
  else
    return '<Tab>'
  end
end, { expr = true })
```

**Verify completion source includes snippets:**
```lua
-- For blink.cmp
:lua print(vim.inspect(require('blink.cmp').get_config().sources.default))
-- Should include 'snippets'

-- For nvim-cmp
:lua print(vim.inspect(require('cmp').get_config().sources))
-- Should include { name = 'luasnip' }
```

### Performance Issues

**Load only needed languages:**
```lua
require('luasnip.loaders.from_vscode').lazy_load({
  include = { 'javascript', 'typescript', 'python' }  -- Only what you use
})
```

**Lazy load on filetype:**
```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'python' },
  callback = function()
    require('luasnip.loaders.from_vscode').lazy_load({
      include = { vim.bo.filetype }
    })
  end,
})
```

## Related Plugins and Resources

### Snippet Engines
- **LuaSnip**: Lua-based snippet engine (recommended for Neovim)
- **vim-vsnip**: VSCode-style snippets in Vimscript
- **UltiSnips**: Python-based, powerful but slower
- **coc-snippets**: For coc.nvim users

### Snippet Collections
- **vim-snippets**: Alternative collection (UltiSnips format)
- **honza/vim-snippets**: Original snippet collection
- **Custom snippets**: Create your own in `~/.config/nvim/snippets/`

### Tools and Extensions
- **telescope-luasnip.nvim**: Browse and search snippets with Telescope
- **LuaSnip-snippets.nvim**: Additional Neovim-specific snippets
- **nvim-scissors**: Visual snippet editor for Neovim

### Documentation
- **Snippet format**: VSCode snippet syntax documentation
- **LuaSnip docs**: `:help luasnip` for advanced features
- **GitHub repo**: https://github.com/rafamadriz/friendly-snippets

---

*For the complete list of available snippets and languages, visit the [official repository](https://github.com/rafamadriz/friendly-snippets).*
