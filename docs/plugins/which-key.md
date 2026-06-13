# which-key.nvim

## Overview

**which-key.nvim** is a powerful Neovim plugin created by Folke Lemaitre that helps you remember and discover keybindings by displaying available key mappings in a popup window as you type. It serves as an interactive keymap reference and makes complex keybinding schemes more accessible and discoverable.

**Repository**: [folke/which-key.nvim](https://github.com/folke/which-key.nvim)

## Key Features

### 🔍 **Interactive Key Discovery**
- Shows available keybindings in a popup as you type
- Displays key descriptions and groups for better organization
- Helps discover forgotten or unknown keybindings

### ⌨️ **Multi-Mode Support**
- Works in Normal, Insert, Visual, Operator Pending, Terminal, and Command modes
- Each mode can be individually enabled/disabled
- Mode-specific keybinding display

### 🎨 **Customizable Interface**
- Multiple layout presets: `classic`, `modern`, `helix`
- Customizable window appearance and positioning
- Icon support with Nerd Fonts
- Flexible sorting options (local, order, group, alphanum, etc.)

### 🛠️ **Built-in Plugins**
- **Marks**: Shows buffer local and global marks when pressing `` ` `` or `'`
- **Registers**: Shows registers when pressing `"` (normal) or `<C-r>` (insert)
- **Presets**: Built-in help for motions, text-objects, operators, windows, nav, z, and g
- **Spelling**: Enhanced spelling suggestions interface

### 🔄 **Flexible Configuration**
- Group and organize keybindings logically
- Dynamic keymap generation
- Conditional keybinding display
- Integration with other plugins

## Requirements

- **Neovim**: ≥ 0.9.4
- **Optional Dependencies**:
  - `mini.icons` or `nvim-web-devicons` (for icons)
  - Nerd Font (for proper icon display)

## Installation

### Using lazy.nvim

```lua
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Configuration options go here
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
```

### Using packer.nvim

```lua
use {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup {
      -- Configuration options
    }
  end
}
```

## Configuration

### Basic Setup

```lua
require("which-key").setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 0,

  -- Preset configuration
  preset = "classic", -- "classic" | "modern" | "helix"

  -- Icon configuration
  icons = {
    mappings = vim.g.have_nerd_font,
    keys = vim.g.have_nerd_font and {} or {
      Up = "<Up> ",
      Down = "<Down> ",
      Left = "<Left> ",
      Right = "<Right> ",
      C = "<C-…> ",
      M = "<M-…> ",
      CR = "<CR> ",
      Esc = "<Esc> ",
      Space = "<Space> ",
      Tab = "<Tab> ",
    },
  },

  -- Key group definitions
  spec = {
    { "<leader>s", group = "[S]earch" },
    { "<leader>g", group = "[G]it" },
    { "<leader>t", group = "[T]oggle" },
  },
}
```

### Advanced Configuration Options

```lua
require("which-key").setup {
  delay = function(ctx)
    return ctx.plugin and 0 or 200
  end,

  filter = function(mapping)
    -- Filter out mappings you don't want to show
    return mapping.desc and mapping.desc ~= ""
  end,

  spec = {
    -- Mode-specific mappings
    { "<leader>f", group = "File", mode = "n" },
    { "<leader>f", group = "Find", mode = "v" },

    -- Conditional mappings
    {
      "<leader>g",
      group = "Git",
      cond = function()
        return vim.fn.isdirectory(".git") == 1
      end
    },
  },

  -- Window configuration
  win = {
    border = "rounded",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 1, 2, 1, 2 },
    winblend = 0,
    zindex = 1000,
  },

  -- Layout configuration
  layout = {
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "left",
  },

  -- Sorting options
  sort = { "local", "order", "group", "alphanum", "mod" },
}
```

## Usage Examples

### Adding Keybindings

#### Method 1: Using `spec` in setup

```lua
require("which-key").setup {
  spec = {
    { "<leader>f", group = "File" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },

    -- Group with multiple modes
    { "<leader>h", group = "Git Hunk", mode = { "n", "v" } },
    { "<leader>hs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk", mode = "n" },
    { "<leader>hs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk", mode = "v" },
  }
}
```

#### Method 2: Using `add()` function

```lua
local wk = require("which-key")

-- Single mapping
wk.add({ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" })

-- Group of mappings
wk.add({
  { "<leader>g", group = "Git" },
  { "<leader>gs", "<cmd>Git status<cr>", desc = "Status" },
  { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
  { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
})

-- Conditional mappings
wk.add({
  {
    "<leader>d",
    group = "Debug",
    cond = function()
      return package.loaded.dap ~= nil
    end
  },
  { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
  { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
})
```

### Complex Example: ChatGPT Integration

```lua
local wk = require("which-key")

wk.add({
  { "<leader>C", group = "[C]hatGPT" },
  { "<leader>CC", "<cmd>ChatGPTCompleteCode<CR>", desc = "Complete Code", mode = "n" },
  { "<leader>Ce", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with Instructions", mode = "n" },
  { "<leader>Cg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = { "n", "v" } },
  { "<leader>Ct", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = { "n", "v" } },
  { "<leader>Cd", "<cmd>ChatGPTRun docstring<CR>", desc = "Generate Docstring", mode = { "n", "v" } },
  { "<leader>Co", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
  { "<leader>Cf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
})
```

### Dynamic Keybindings Based on Filetype

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    require("which-key").add({
      { "<leader>r", group = "Rust", buffer = 0 },
      { "<leader>rr", "<cmd>RustRun<cr>", desc = "Run", buffer = 0 },
      { "<leader>rt", "<cmd>RustTest<cr>", desc = "Test", buffer = 0 },
      { "<leader>rc", "<cmd>RustOpenCargo<cr>", desc = "Open Cargo.toml", buffer = 0 },
    })
  end,
})
```

## Configuration Options Reference

### Core Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `delay` | `number\|function` | `0` | Delay before showing which-key |
| `preset` | `string` | `"classic"` | Layout preset: "classic", "modern", "helix" |
| `filter` | `function` | `nil` | Filter function for mappings |
| `spec` | `table` | `{}` | Key specifications |
| `notify` | `boolean` | `true` | Show notifications |
| `triggers` | `table` | Auto-detected | Trigger keys for which-key |

### Icons Configuration

```lua
icons = {
  breadcrumb = "»",
  separator = "➜",
  group = "+",
  ellipsis = "…",
  mappings = true, -- Use icons for mappings
  rules = {}, -- Custom icon rules
  colors = true, -- Use colors for icons
  keys = {
    Up = " ",
    Down = " ",
    Left = " ",
    Right = " ",
    C = "󰘴 ",
    M = "󰘵 ",
    D = "󰘳 ",
    S = "󰘶 ",
    CR = "󰌑 ",
    Esc = "󱊷 ",
    ScrollWheelDown = "󱕐 ",
    ScrollWheelUp = "󱕑 ",
    NL = "󰌑 ",
    BS = "󰁮",
    Space = "󱁐 ",
    Tab = "󰌒 ",
  },
}
```

### Window Configuration

```lua
win = {
  border = "none", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
  position = "bottom", -- Position: "bottom", "top"
  margin = { 1, 0, 1, 0 }, -- Margin: [top, right, bottom, left]
  padding = { 1, 2, 1, 2 }, -- Padding: [top, right, bottom, left]
  winblend = 0, -- Window transparency (0-100)
  zindex = 1000, -- Window z-index
  bo = {}, -- Buffer options
  wo = {}, -- Window options
}
```

### Layout Configuration

```lua
layout = {
  width = { min = 20, max = 50 }, -- Min and max width
  height = { min = 4, max = 25 }, -- Min and max height
  spacing = 3, -- Spacing between columns
  align = "left", -- Alignment: "left", "center", "right"
}
```

### Sorting Options

Available sort methods:
- `"local"`: Buffer-local mappings first
- `"order"`: Order of registration
- `"group"`: Group mappings together
- `"alphanum"`: Alphanumeric sorting
- `"mod"`: Sort by modifier keys
- `"manual"`: Manual sorting
- `"lower"`: Case-insensitive
- `"icase"`: Case-insensitive
- `"desc"`: Sort by description

## Common Use Cases

### 1. **LSP Keybindings Organization**

```lua
wk.add({
  { "<leader>l", group = "LSP" },
  { "<leader>ld", vim.lsp.buf.definition, desc = "Go to Definition" },
  { "<leader>lh", vim.lsp.buf.hover, desc = "Hover Documentation" },
  { "<leader>lr", vim.lsp.buf.references, desc = "Find References" },
  { "<leader>ln", vim.lsp.buf.rename, desc = "Rename Symbol" },
  { "<leader>lf", vim.lsp.buf.format, desc = "Format Document" },
  { "<leader>la", vim.lsp.buf.code_action, desc = "Code Actions" },
})
```

### 2. **File Management**

```lua
wk.add({
  { "<leader>f", group = "File" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
  { "<leader>fs", "<cmd>w<cr>", desc = "Save File" },
  { "<leader>fq", "<cmd>q<cr>", desc = "Quit" },
  { "<leader>fn", "<cmd>enew<cr>", desc = "New File" },
})
```

### 3. **Buffer Management**

```lua
wk.add({
  { "<leader>b", group = "Buffer" },
  { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "List Buffers" },
  { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },
  { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
  { "<leader>bp", "<cmd>bprev<cr>", desc = "Previous Buffer" },
  { "<leader>bh", "<cmd>new<cr>", desc = "Horizontal Split" },
  { "<leader>bv", "<cmd>vnew<cr>", desc = "Vertical Split" },
})
```

### 4. **Git Integration**

```lua
wk.add({
  { "<leader>g", group = "Git" },
  { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
  { "<leader>gs", "<cmd>Git status<cr>", desc = "Status" },
  { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
  { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
  { "<leader>gP", "<cmd>Git pull<cr>", desc = "Pull" },
  { "<leader>gb", "<cmd>Git blame<cr>", desc = "Blame" },
  { "<leader>gl", "<cmd>Git log<cr>", desc = "Log" },
})
```

### 5. **Debugging Setup**

```lua
wk.add({
  {
    "<leader>d",
    group = "Debug",
    cond = function()
      return package.loaded.dap ~= nil
    end
  },
  { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
  { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
  { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
  { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
  { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step Out" },
  { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
  { "<leader>du", "<cmd>DapUIToggle<cr>", desc = "Toggle UI" },
})
```

## API Reference

### Core Functions

#### `setup(opts)`
Initialize which-key with configuration options.

```lua
require("which-key").setup({
  delay = 0,
  preset = "classic",
  spec = {}
})
```

#### `add(mappings, opts)`
Add key mappings to which-key.

```lua
local wk = require("which-key")
wk.add({
  { "<leader>f", group = "File" },
  { "<leader>ff", "<cmd>find<cr>", desc = "Find File" }
})
```

#### `show(opts)`
Manually trigger which-key display.

```lua
require("which-key").show({
  mode = "n",
  global = false,
  buffer = nil
})
```

### Utility Functions

#### `register(mappings, opts)` (Legacy)
Legacy function for registering mappings (still supported).

```lua
local wk = require("which-key")
wk.register({
  f = {
    name = "File",
    f = { "<cmd>find<cr>", "Find File" }
  }
}, { prefix = "<leader>" })
```

## Related Plugins and Alternatives

### Complementary Plugins

1. **[folke/lazy.nvim](https://github.com/folke/lazy.nvim)** - Modern plugin manager (same author)
2. **[nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder (works great with which-key)
3. **[lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git integration
4. **[hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - Completion engine

### Alternatives

1. **[liuchengxu/vim-which-key](https://github.com/liuchengxu/vim-which-key)** - Original Vim version
2. **[anuvyklack/hydra.nvim](https://github.com/anuvyklack/hydra.nvim)** - Different approach to key binding management
3. **[AckslD/nvim-whichkey-setup.lua](https://github.com/AckslD/nvim-whichkey-setup.lua)** - Alternative setup for which-key

## Tips and Best Practices

### 1. **Organize by Functionality**
Group related commands under logical prefixes:
```lua
-- Good organization
{ "<leader>f", group = "File" }
{ "<leader>g", group = "Git" }
{ "<leader>l", group = "LSP" }
{ "<leader>d", group = "Debug" }
```

### 2. **Use Descriptive Names**
Make descriptions clear and actionable:
```lua
-- Good descriptions
{ "<leader>ff", desc = "Find Files" }
{ "<leader>lg", desc = "Live Grep" }
{ "<leader>gs", desc = "Git Status" }

-- Avoid vague descriptions
{ "<leader>ff", desc = "Files" } -- Too vague
```

### 3. **Consistent Prefix Patterns**
Establish consistent patterns for your prefixes:
```lua
-- Consistent pattern
{ "<leader>s", group = "[S]earch" }
{ "<leader>t", group = "[T]oggle" }
{ "<leader>g", group = "[G]it" }
```

### 4. **Mode-Specific Mappings**
Use different mappings for different modes when appropriate:
```lua
wk.add({
  { "<leader>v", group = "Visual", mode = "v" },
  { "<leader>vs", ":sort<cr>", desc = "Sort Lines", mode = "v" },
  { "<leader>vu", ":s/\\v(.)/\\u\\1/g<cr>", desc = "Uppercase", mode = "v" },
})
```

### 5. **Conditional Mappings**
Only show mappings when relevant:
```lua
wk.add({
  {
    "<leader>d",
    group = "Debug",
    cond = function()
      return vim.bo.filetype == "python" and package.loaded.dap
    end
  }
})
```

### 6. **Buffer-Local Mappings**
Use buffer-local mappings for filetype-specific commands:
```lua
-- In after/ftplugin/rust.lua
require("which-key").add({
  { "<leader>r", group = "Rust", buffer = 0 },
  { "<leader>rr", "<cmd>RustRun<cr>", desc = "Run", buffer = 0 },
})
```

## Troubleshooting

### Common Issues

1. **Keys not showing up**: Check if `desc` is provided and mappings are properly registered
2. **Wrong icons**: Ensure Nerd Font is installed and `have_nerd_font` is set correctly
3. **Delay issues**: Adjust `delay` setting or check `timeoutlen` vim option
4. **Mode conflicts**: Verify mode-specific mappings are correctly configured

### Debug Commands

```lua
-- Show all registered mappings
:WhichKey

-- Check which-key status
:lua print(vim.inspect(require("which-key").mappings))

-- Show buffer-local mappings only
:lua require("which-key").show({ global = false })
```

## Migration from v2 to v3

which-key v3 introduced breaking changes. Here's how to migrate:

### Old v2 syntax:
```lua
wk.register({
  f = {
    name = "File",
    f = { "<cmd>find<cr>", "Find File" }
  }
}, { prefix = "<leader>" })
```

### New v3 syntax:
```lua
wk.add({
  { "<leader>f", group = "File" },
  { "<leader>ff", "<cmd>find<cr>", desc = "Find File" }
})
```

### Key changes:
- `register()` → `add()`
- Flat table structure instead of nested
- `name` → `group`
- Direct key specification instead of prefix-based
- `desc` for descriptions

This comprehensive guide should help you understand and effectively use which-key.nvim in your Neovim configuration.