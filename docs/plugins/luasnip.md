# LuaSnip

LuaSnip is a powerful snippet engine for Neovim written entirely in Lua. It provides advanced snippet functionality with extensive customization options, dynamic content generation, and seamless integration with completion engines.

## Overview and Purpose

LuaSnip serves as a sophisticated text expansion system that goes far beyond simple text replacement. It enables developers to create intelligent, context-aware snippets that can generate complex code structures, handle user input dynamically, and adapt to different programming contexts.

### Key Design Philosophy
- **Lua-based**: Written entirely in Lua for maximum flexibility and performance
- **Extensible**: Supports custom node types and complex snippet logic
- **Interactive**: Provides tabstops, choices, and dynamic content generation
- **Compatible**: Works seamlessly with popular completion engines

## Key Features and Capabilities

### Core Features
- **Multiple Node Types**: Text, Insert, Function, Choice, Dynamic, and Restore nodes
- **Advanced Tabstops**: Navigate between editable positions with complex transformations
- **Conditional Expansion**: Context-aware snippet triggering based on filetype, cursor position, etc.
- **Nested Snippets**: Support for snippets within snippets
- **Regex Support**: Pattern-based transformations and advanced text manipulation
- **LSP Integration**: Compatible with Language Server Protocol snippet format

### Advanced Capabilities
- **Dynamic Content Generation**: Create snippets that adapt based on user input
- **Choice Nodes**: Allow users to select between predefined options
- **Function Nodes**: Generate content programmatically using Lua functions
- **Auto-triggering**: Snippets that expand automatically based on patterns
- **Multi-line Support**: Complex snippets spanning multiple lines with proper indentation

## Installation and Configuration

### Requirements
- Neovim >= 0.7
- Optional: `jsregexp` for advanced regex transformations (recommended)

### Installation with Lazy.nvim

```lua
{
  'L3MON4D3/LuaSnip',
  version = '2.*',
  build = (function()
    -- Build Step is needed for regex support in snippets
    -- This step is not supported in many Windows environments
    -- Remove the below condition to re-enable on Windows
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      return
    end
    return 'make install_jsregexp'
  end)(),
  dependencies = {
    -- Optional: Pre-made snippets from friendly-snippets
    {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },
  config = function()
    local ls = require('luasnip')

    -- Enable autotrigger snippets
    ls.config.set_config({
      -- Enable autotriggered snippets
      enable_autosnippets = true,
      -- Use Tab (or some other key if you prefer) to trigger visual selection
      store_selection_keys = "<Tab>",
    })
  end,
}
```

### Installation with Packer

```lua
use({
  'L3MON4D3/LuaSnip',
  tag = 'v2.*',
  run = 'make install_jsregexp',
  requires = {
    'rafamadriz/friendly-snippets',
  },
})
```

## Basic Configuration

### Essential Keymaps

```lua
local ls = require('luasnip')

-- Expand snippet or jump to next tabstop
vim.keymap.set({'i', 's'}, '<C-L>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- Jump to previous tabstop
vim.keymap.set({'i', 's'}, '<C-J>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- Change choice in choice nodes
vim.keymap.set({'i', 's'}, '<C-E>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })
```

### Integration with Completion Engines

#### With blink.cmp

```lua
{
  'saghen/blink.cmp',
  opts = {
    snippets = { preset = 'luasnip' },
    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },
  },
}
```

#### With nvim-cmp

```lua
{
  'hrsh7th/nvim-cmp',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        -- other sources...
      },
    })
  end,
}
```

## Snippet Creation and Management

### Basic Snippet Structure

```lua
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Simple snippet
s("hello", {
  t("Hello, "),
  i(1, "World"),
  t("!")
})
```

### Node Types

#### Text Nodes
Static text that doesn't change:
```lua
t("Hello, World!")
t({"Line 1", "Line 2", "Line 3"}) -- Multi-line
```

#### Insert Nodes
Editable positions with optional placeholder text:
```lua
i(1, "placeholder text")  -- Tabstop 1
i(2)                      -- Tabstop 2 (empty)
i(0)                      -- Final tabstop (exit point)
```

#### Function Nodes
Generate content dynamically:
```lua
local f = ls.function_node

s("date", {
  t("Today is "),
  f(function() return os.date("%Y-%m-%d") end, {}),
})
```

#### Choice Nodes
Allow selection between options:
```lua
local c = ls.choice_node

s("class", {
  t("class "),
  i(1, "ClassName"),
  t(" "),
  c(2, {
    t("extends BaseClass"),
    t("implements Interface"),
    t(""),
  }),
  t(" {"),
  i(0),
  t("}"),
})
```

### Creating Custom Snippets

#### Snippet Files Organization

Create snippets in `~/.config/nvim/luasnip/`:

```
luasnip/
├── all.lua          -- Global snippets
├── lua.lua          -- Lua-specific snippets
├── javascript.lua   -- JavaScript snippets
└── python.lua       -- Python snippets
```

#### Example: Custom Lua Snippets

```lua
-- ~/.config/nvim/luasnip/lua.lua
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node

return {
  -- Function snippet
  s("fn", {
    t("function "),
    i(1, "name"),
    t("("),
    i(2, "args"),
    t(")"),
    t({"", "  "}),
    i(3, "-- body"),
    t({"", "end"}),
  }),

  -- Conditional snippet
  s("if", {
    t("if "),
    i(1, "condition"),
    t(" then"),
    t({"", "  "}),
    i(2, "-- body"),
    t({"", "end"}),
  }),

  -- Table snippet with choices
  s("tbl", {
    c(1, {
      t("local "),
      t(""),
    }),
    i(2, "table_name"),
    t(" = {"),
    t({"", "  "}),
    i(3),
    t({"", "}"}),
  }),
}
```

### Loading Custom Snippets

```lua
-- Load snippets from custom directory
require('luasnip.loaders.from_lua').load({
  paths = "~/.config/nvim/luasnip/"
})

-- Load VS Code style snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- Load SnipMate style snippets
require('luasnip.loaders.from_snipmate').lazy_load()
```

## Advanced Features

### Dynamic Nodes

Dynamic nodes generate content based on other nodes' values:

```lua
local d = ls.dynamic_node

s("class", {
  t("class "),
  i(1, "ClassName"),
  t(" {"),
  t({"", "  constructor("}),
  i(2, "params"),
  t(") {"),
  t({"", "    "}),
  d(3, function(args)
    local class_name = args[1][1]
    return s(nil, {
      t("this.name = '"),
      t(class_name),
      t("';"),
    })
  end, {1}),
  t({"", "  }"}),
  t({"", "}"}),
})
```

### Choice Nodes with Complex Options

```lua
s("log", {
  t("console."),
  c(1, {
    t("log"),
    t("warn"),
    t("error"),
    t("info"),
    t("debug"),
  }),
  t("("),
  c(2, {
    i(nil, "'message'"),
    i(nil, "variable"),
    sn(nil, {
      t("'"),
      i(1, "message"),
      t("', "),
      i(2, "variable"),
    }),
  }),
  t(");"),
})
```

### Conditional Snippets

Snippets that expand only under certain conditions:

```lua
-- Only expand in specific contexts
s({
  trig = "req",
  condition = function()
    -- Only expand at the beginning of a line
    return vim.fn.col('.') == 1
  end
}, {
  t("const "),
  i(1, "module"),
  t(" = require('"),
  f(function(args) return args[1][1] end, {1}),
  t("');"),
})
```

### Auto-triggering Snippets

```lua
-- Enable autosnippets in configuration
ls.config.set_config({
  enable_autosnippets = true,
})

-- Create autosnippet
s({
  trig = "=>",
  snippetType = "autosnippet",
}, {
  t(" => "),
})
```

## Configuration Options

### Global Configuration

```lua
require('luasnip').config.set_config({
  -- Remember the last snippet so you can jump back
  history = true,

  -- Update dynamic snippets as you type
  updateevents = "TextChanged,TextChangedI",

  -- Enable autotriggered snippets
  enable_autosnippets = true,

  -- Use tab to trigger visual selection
  store_selection_keys = "<Tab>",

  -- Configure behavior when deleting snippet
  delete_check_events = "TextChanged",
})
```

### Filetype-specific Configuration

```lua
-- Set filetype-specific options
ls.filetype_extend("javascript", {"html"})
ls.filetype_extend("typescript", {"javascript"})
```

## Usage Examples and Workflow

### Daily Workflow Integration

1. **Code Templates**: Create snippets for common code patterns
2. **Documentation**: Generate function documentation automatically
3. **Boilerplate**: Quickly scaffold new files or components
4. **Debugging**: Insert console.log statements with proper formatting

### Example: React Component Snippet

```lua
s("rfc", {
  t("import React from 'react';"),
  t({"", "", "interface "}),
  i(1, "Component"),
  t("Props {"),
  t({"", "  "}),
  i(2, "// props"),
  t({"", "}"}),
  t({"", "", "const "}),
  f(function(args) return args[1][1] end, {1}),
  t(": React.FC<"),
  f(function(args) return args[1][1] end, {1}),
  t("Props> = ("),
  i(3, "props"),
  t(") => {"),
  t({"", "  return ("}),
  t({"", "    "}),
  i(4, "<div>Component</div>"),
  t({"", "  );"}),
  t({"", "};"}),
  t({"", "", "export default "}),
  f(function(args) return args[1][1] end, {1}),
  t(";"),
})
```

## Common Use Cases

### 1. Code Generation
- Class and function templates
- Import statements
- Configuration files
- Test cases

### 2. Documentation
- JSDoc comments
- README sections
- API documentation
- Inline comments

### 3. Debugging
- Console logging
- Error handling
- Debug statements
- Performance measurements

### 4. Boilerplate Reduction
- File headers
- License information
- Author signatures
- Standard structures

## Related Plugins and Alternatives

### Complementary Plugins
- **friendly-snippets**: Pre-made snippet collection
- **nvim-cmp**: Completion engine integration
- **blink.cmp**: Modern completion engine
- **which-key.nvim**: Discover snippet keybindings

### Alternative Snippet Engines
- **UltiSnips**: Python-based snippet engine
- **SnipMate**: Vim-script based engine
- **vim-vsnip**: VS Code snippet support

### Migration Tools
- **UltiSnips converter**: Convert UltiSnips to LuaSnip format
- **VS Code importer**: Import VS Code snippets directly

## Performance Considerations

### Optimization Tips
1. **Lazy Loading**: Load snippets only when needed
2. **Conditional Loading**: Use filetype-specific loading
3. **Efficient Patterns**: Avoid complex regex in triggers
4. **Memory Management**: Clean up unused snippets

### Best Practices
- Keep snippets simple and focused
- Use descriptive trigger names
- Organize snippets by functionality
- Test snippets regularly
- Document complex snippet logic

## Troubleshooting

### Common Issues
1. **Snippets not expanding**: Check trigger conditions and keymaps
2. **Performance problems**: Review snippet complexity and loading strategy
3. **Conflicts with other plugins**: Ensure proper keymap precedence
4. **Missing features**: Verify jsregexp installation

### Debug Mode
```lua
-- Enable debug logging
require('luasnip').log.set_loglevel("info")
```

This comprehensive guide covers LuaSnip's core functionality and advanced features. For the most up-to-date information and detailed API documentation, refer to the [official repository](https://github.com/L3MON4D3/LuaSnip).