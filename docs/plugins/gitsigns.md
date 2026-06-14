# Gitsigns.nvim

Lewis6991's gitsigns.nvim is a comprehensive Git integration plugin for Neovim that provides deep buffer-level Git functionality. It offers visual indicators for code changes, powerful hunk management, and seamless Git workflow integration directly within the editor.

## Overview and Purpose

Gitsigns.nvim transforms Neovim into a Git-aware editor by:
- Adding visual indicators (signs) in the sign column for changed, added, and deleted lines
- Providing comprehensive hunk management capabilities
- Offering Git blame information and diff functionality
- Enabling seamless Git workflow operations without leaving the editor

The plugin is implemented entirely in Lua, leveraging Neovim's built-in diff library and providing async operations for optimal performance.

## Key Features and Capabilities

### Visual Git Integration
- **Signs in Sign Column**: Visual indicators for added (`+`), changed (`~`), deleted (`_`), top-deleted (`‾`), change-deleted (`~`), and untracked (`┆`) lines
- **Line Highlighting**: Optional highlighting of changed lines in number column (`numhl`) or entire lines (`linehl`)
- **Staged Change Tracking**: Different visual indicators for staged vs unstaged changes
- **Customizable Signs**: Fully customizable sign characters and colors

### Hunk Management
- **Stage/Unstage Hunks**: Stage or unstage individual hunks or selected ranges
- **Reset Hunks**: Revert specific changes to working directory state
- **Hunk Navigation**: Jump between changes with `]c` and `[c`
- **Hunk Preview**: Preview changes in floating windows or inline
- **Partial Staging**: Stage only selected lines within a hunk

### Blame and History
- **Current Line Blame**: Show Git blame information for the current line
- **Buffer Blame**: Display blame for the entire buffer
- **Blame Formatting**: Customizable blame text format and positioning
- **Historical Comparison**: Compare against different revisions

### Diff Functionality
- **Base Revision**: Change the base revision for sign comparison
- **Diff Against Index**: Compare working directory against staged changes
- **Diff Against Commit**: Compare against specific commits
- **Word-level Diff**: Highlight changes at the word level within lines

## Installation and Configuration

### Basic Installation

```lua
{
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
  },
}
```

### Current Configuration

This Neovim configuration includes gitsigns.nvim in two locations:

1. **Basic setup in init.lua** (lines 274-285):
```lua
{
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
}
```

2. **Extended configuration with keymaps** in `lua/kickstart/plugins/gitsigns.lua`

## Usage Examples and Keymaps

### Navigation Keymaps
- `]c` - Jump to next git change (hunk)
- `[c` - Jump to previous git change (hunk)

### Hunk Actions
- `<leader>hs` - Stage hunk (normal mode) or stage selected lines (visual mode)
- `<leader>hr` - Reset hunk (normal mode) or reset selected lines (visual mode)
- `<leader>hS` - Stage entire buffer
- `<leader>hu` - Undo stage hunk
- `<leader>hR` - Reset entire buffer
- `<leader>hp` - Preview hunk in floating window

### Blame and Diff
- `<leader>hb` - Show Git blame for current line
- `<leader>hd` - Diff against index (staged changes)
- `<leader>hD` - Diff against last commit (`@`)

### Toggles
- `<leader>tb` - Toggle current line blame display
- `<leader>tD` - Toggle deleted lines preview inline

### Command Examples

```vim
" Toggle various display options
:Gitsigns toggle_signs
:Gitsigns toggle_numhl
:Gitsigns toggle_linehl
:Gitsigns toggle_current_line_blame

" Manual operations
:Gitsigns stage_hunk
:Gitsigns reset_hunk
:Gitsigns preview_hunk
:Gitsigns blame_line
```

## Configuration Options

### Complete Configuration Example

```lua
require('gitsigns').setup {
  -- Sign column configuration
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },

  -- Display options
  signcolumn = true,          -- Show signs in sign column
  numhl = false,             -- Highlight line numbers
  linehl = false,            -- Highlight entire lines
  word_diff = false,         -- Enable word diff

  -- Blame configuration
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
    ignore_whitespace = false,
  },

  -- Performance and behavior
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  sign_priority = 6,
  update_debounce = 100,

  -- Diff configuration
  diff_opts = {
    algorithm = 'myers',
    internal = false,
  },

  -- Preview configuration
  preview_config = {
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}
```

### Key Configuration Options

- **`signs`**: Customize the characters used for different change types
- **`signcolumn`**: Enable/disable signs in the sign column
- **`numhl/linehl`**: Highlight line numbers or entire lines
- **`current_line_blame`**: Show blame information for the current line
- **`attach_to_untracked`**: Show signs for untracked files
- **`word_diff`**: Enable word-level diff highlighting
- **`update_debounce`**: Milliseconds to wait before updating signs

## Integration with Other Tools

### Statusline Integration

Gitsigns provides buffer variables for statusline integration:

```lua
-- Available buffer variables
vim.b.gitsigns_status     -- Formatted git status (e.g., "+2 ~1 -3")
vim.b.gitsigns_head       -- Current branch name
vim.b.gitsigns_status_dict -- Detailed status information
```

### Integration with This Configuration

This Neovim configuration integrates gitsigns with:

1. **Barbar.nvim**: Listed as an optional dependency for Git status in tabs
2. **Snacks.nvim**: Provides additional Git functionality that complements gitsigns
3. **Which-key.nvim**: All gitsigns keymaps are documented and discoverable

### Integration with External Tools

- **vim-fugitive**: Works seamlessly alongside fugitive for comprehensive Git workflow
- **trouble.nvim**: Can display gitsigns diagnostics in trouble windows
- **telescope.nvim**: Can be extended to search Git hunks and blame information

## Common Use Cases

### Daily Development Workflow

1. **Review Changes**: Use signs to quickly identify modified areas
2. **Stage Selectively**: Stage individual hunks or lines with `<leader>hs`
3. **Preview Before Staging**: Use `<leader>hp` to review changes
4. **Navigate Changes**: Use `]c` and `[c` to move between hunks
5. **Reset Mistakes**: Use `<leader>hr` to revert unwanted changes

### Code Review

1. **Blame Investigation**: Use `<leader>hb` to see who last modified a line
2. **Historical Comparison**: Use `<leader>hD` to see changes since last commit
3. **Word-level Analysis**: Enable `word_diff` for detailed change inspection

### Team Collaboration

1. **Conflict Resolution**: Navigate between conflict markers
2. **Change Attribution**: Use blame features to understand code history
3. **Selective Commits**: Stage only relevant changes using hunk staging

## Performance Considerations

- **Async Operations**: All Git operations are asynchronous
- **Debounced Updates**: Signs update with configurable debouncing
- **Efficient Diffing**: Uses Neovim's built-in diff library
- **Memory Efficient**: No external dependencies beyond Git

## Related Plugins and Alternatives

### Complementary Plugins
- **vim-fugitive**: Full-featured Git wrapper (works alongside gitsigns)
- **neogit**: Magit-like Git interface for Neovim
- **diffview.nvim**: Advanced diff viewing capabilities
- **git-conflict.nvim**: Enhanced conflict resolution

### Alternative Plugins
- **vim-gitgutter**: Similar functionality but for Vim
- **coc-git**: Git integration for coc.nvim
- **airblade/vim-gitgutter**: Vim-specific Git signs plugin

### Why Choose Gitsigns

- **Native Neovim**: Built specifically for Neovim with Lua
- **Performance**: Async operations with minimal overhead
- **Feature Complete**: Comprehensive Git integration
- **Active Development**: Well-maintained with regular updates
- **Extensible**: Highly configurable with good API

## Troubleshooting

### Common Issues

1. **Signs not appearing**: Check if Git repository is properly initialized
2. **Performance issues**: Adjust `update_debounce` and `watch_gitdir.interval`
3. **Keymap conflicts**: Review keymap configuration in `on_attach` function

### Debug Information

```vim
:Gitsigns debug_messages    " Show debug information
:Gitsigns dump_cache       " Display cache information
```

## Requirements

- **Neovim**: >= 0.9.0
- **Git**: Relatively recent version
- **Operating System**: Cross-platform (Linux, macOS, Windows)

This comprehensive Git integration makes gitsigns.nvim an essential plugin for any serious Neovim-based development workflow, providing the visual feedback and workflow tools needed for efficient Git operations.