# guess-indent.nvim

**Repository**: [NMAC427/guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim)

## Overview

Automatic indentation style detection for Neovim. This plugin automatically detects whether a file uses tabs or spaces for indentation and adjusts your editor settings accordingly.

## Purpose

- Automatically detect tab vs spaces indentation
- Determine indentation width (2, 4, 8 spaces, etc.)
- Update buffer options to match detected style
- Provides blazing fast detection (< 1ms typically)

## Key Features

- **Fast Detection**: Blazing fast indentation detection (< 1ms typically)
- **Automatic Updates**: Updates `tabstop`, `shiftwidth`, and `expandtab` options
- **Minimal Configuration**: Works out of the box with no configuration
- **Cross-Language**: Works with any file type
- **Sublime Text Compatibility**: Mimics Sublime Text's "Guess Indentation Settings From Buffer"

## Installation

```lua
{
  'NMAC427/guess-indent.nvim',
  config = function()
    require('guess-indent').setup()
  end,
}
```

## Configuration

### Basic Setup
```lua
require('guess-indent').setup {}
```

### Complete Configuration Options
```lua
require('guess-indent').setup {
  auto_cmd = true,  -- Set to false to disable the autocmd
  override_editorconfig = false,  -- Set to true to override .editorconfig settings
  filetype_exclude = {  -- A list of filetypes for which the auto command gets disabled
    "netrw",
    "tutor",
  },
  buftype_exclude = {  -- A list of buffer types for which the auto command gets disabled
    "help",
    "nofile",
    "terminal",
    "prompt",
  },
  on_tab_options = {  -- Buffer options to set when tabs are detected
    ["expandtab"] = false,
  },
  on_space_options = {  -- Buffer options to set when spaces are detected
    ["expandtab"] = true,
    ["tabstop"] = "detected",  -- "detected" or a specific number
    ["softtabstop"] = "detected",
    ["shiftwidth"] = "detected",
  },
}
```

### Configuration Options Explained

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `auto_cmd` | boolean | `true` | Enable/disable automatic execution on buffer open |
| `override_editorconfig` | boolean | `false` | Override .editorconfig settings with detected values |
| `filetype_exclude` | table | `{"netrw", "tutor"}` | List of filetypes to exclude from auto-detection |
| `buftype_exclude` | table | `{"help", "nofile", "terminal", "prompt"}` | List of buffer types to exclude |
| `on_tab_options` | table | `{["expandtab"] = false}` | Buffer options to set when tabs are detected |
| `on_space_options` | table | See above | Buffer options to set when spaces are detected |

## Commands

| Command | Description |
|---------|-------------|
| `:GuessIndent` | Manually trigger indentation detection for current buffer |

## How It Works

1. Analyzes the first few lines of a file
2. Counts tab vs space indentation patterns
3. Determines the most common indentation width
4. Updates buffer settings automatically

## Use Cases

- **Multi-Project Development**: Working with codebases that have different indentation styles
- **Code Consistency**: Ensuring your editor matches the project's existing style
- **Team Development**: Automatically adapting to team coding standards
- **Open Source Contributions**: Matching existing project conventions

## Integration

This plugin works automatically in the background. Once installed and configured, it will:

1. Run automatically when opening files
2. Update your buffer settings silently
3. Ensure consistent indentation without manual intervention

## Usage Examples

### Automatic Detection
The plugin works automatically when you open files:
```
# Opening a file with 2-space indentation
:edit main.py
# Plugin automatically detects and sets shiftwidth=2, expandtab=true

# Opening a file with tab indentation
:edit Makefile
# Plugin automatically detects and sets expandtab=false
```

### Manual Detection
You can manually trigger detection:
```
:GuessIndent
```

### Checking Current Settings
After detection, verify the settings:
```
:set shiftwidth?
:set expandtab?
:set tabstop?
```

## Related Plugins and Alternatives

### Similar Plugins
- **[vim-sleuth](https://github.com/tpope/vim-sleuth)**: Tim Pope's classic indentation detection plugin
  - Pros: Mature, battle-tested, Vim-compatible
  - Cons: Slower performance, less configurable

- **[indent-o-matic](https://github.com/Darazaki/indent-o-matic)**: Another Lua-based alternative
  - Pros: Simple algorithm, lightweight
  - Cons: Less sophisticated detection heuristics

### Why Choose guess-indent.nvim?
- **Performance**: Blazing fast (< 1ms) detection
- **Modern**: Written in Lua for Neovim
- **Flexible**: Highly configurable with override options
- **EditorConfig Support**: Can respect or override .editorconfig settings
- **Comprehensive**: Detects both tab/space preference and indentation width

## Troubleshooting

### Common Issues

**Plugin not detecting indentation:**
- Check if filetype is excluded: `:lua print(vim.inspect(require('guess-indent').config.filetype_exclude))`
- Manually trigger: `:GuessIndent`
- Verify buffer type isn't excluded

**Conflicts with .editorconfig:**
- Set `override_editorconfig = true` to prioritize detection over .editorconfig
- Or disable auto_cmd and use manual detection selectively

**Wrong detection in mixed indentation files:**
- The plugin analyzes first few hundred lines - ensure consistent indentation at file start
- Consider manual correction for edge cases

## Configuration in Your Setup

In your configuration, this plugin is loaded as:

```lua
'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
```

The plugin runs automatically without explicit setup call, providing seamless indentation detection across all file types.