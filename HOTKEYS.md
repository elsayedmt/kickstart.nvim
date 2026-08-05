# Neovim Hotkeys Reference

Quick reference for useful Neovim keybindings in this configuration.

## Standard Vim Commands (Super Useful!)
- `ZZ` - Save current file and quit (same as `:wq`)
- `ZQ` - Quit without saving (same as `:q!`)
- `<C-o>` - Jump back to previous location in jump list
- `<C-i>` - Jump forward in jump list
- `<C-t>` - Jump back after going to definition (LSP)
- `gf` - Go to file under cursor
- `<C-w>v` - Split window vertically
- `<C-w>s` - Split window horizontally
- `<C-w>q` - Close current window
- `<C-^>` - Switch to alternate file (previously edited)

## Window Navigation
- `<C-h>` - Move to left window
- `<C-l>` - Move to right window
- `<C-j>` - Move to lower window
- `<C-k>` - Move to upper window

## Search and Find (Telescope)
- `<leader>sh` - Search help documentation
- `<leader>sk` - Search keymaps
- `<leader>sf` - Search files
- `<leader>sw` - Search current word under cursor
- `<leader>sg` - Live grep (search by content)
- `<leader>sd` - Search diagnostics
- `<leader>sr` - Resume last search
- `<leader>s.` - Search recent files
- `<leader>sn` - Search Neovim config files
- `<leader>s/` - Live grep in open files
- `<leader>/` - Fuzzy search in current buffer
- `<leader><leader>` - Find existing buffers

## LSP (Language Server) Keybindings
- `grn` - Rename symbol under cursor
- `gra` - Code action (fix/refactor)
- `grr` - Go to references
- `gri` - Go to implementation
- `grd` - Go to definition
- `grD` - Go to declaration
- `grt` - Go to type definition
- `gO` - Open document symbols (outline)
- `gW` - Open workspace symbols
- `<leader>th` - Toggle inlay hints

## Code Editing
- `<leader>f` - Format buffer
- `<Esc>` - Clear search highlights (in normal mode)
- `<leader>q` - Open diagnostic quickfix list

## Terminal
- `<Esc><Esc>` - Exit terminal mode (return to normal mode)

## Text Objects (mini.ai)
- `va)` - Visually select around parentheses
- `yinq` - Yank inside next quote
- `ci'` - Change inside single quotes
- `daw` - Delete around word
- `viw` - Visually select inner word
- `vip` - Visually select inner paragraph

## Surroundings (mini.surround)
- `saiw)` - Surround add inner word with parentheses
- `sd'` - Surround delete quotes
- `sr)'` - Surround replace parentheses with quotes

## File Explorer
- `-` - Open parent directory (oil.nvim)
- `<leader>e` - Toggle file explorer (Snacks explorer)

## Git (Gitsigns)
- `<leader>h*` - Git hunk operations (stage, reset, preview, blame, etc.)

## Harpoon (Quick File Navigation)
- `<leader>ma` - Add current file to Harpoon
- `<leader>mm` - Toggle Harpoon menu
- `<leader>1` - Jump to Harpoon file 1
- `<leader>2` - Jump to Harpoon file 2
- `<leader>3` - Jump to Harpoon file 3
- `<leader>4` - Jump to Harpoon file 4
- `<leader>mp` - Previous Harpoon file
- `<leader>mn` - Next Harpoon file
- `<leader>mc` - Clear all Harpoon marks

## Search and Replace (Spectre)
- `<leader>Rr` - Toggle Spectre (project-wide search/replace)
- `<leader>Rw` - Replace current word
- `<leader>Rr` - Replace selection (visual mode)
- `<leader>Rf` - Replace in current file

## Debug (nvim-dap)
- `<F5>` - Start / continue
- `<F1>` / `<F2>` / `<F3>` - Step into / over / out
- `<F7>` - Toggle the debug UI (last session result)
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint

## Markdown Preview
- `<leader>mv` - Toggle browser preview (renders mermaid diagrams & math); markdown buffers only
- `:MarkdownPreview` / `:MarkdownPreviewStop` - Open / stop the preview explicitly

## Plugin Commands
- `:lua vim.pack.update()` - Update all plugins (vim.pack built-in manager)
- `:checkhealth vim.pack` - Check vim.pack plugin health
- `:Mason` - Open Mason LSP/tool installer
- `:Telescope` - Open Telescope picker

## Tips
- `<leader>` is mapped to `<Space>`
- Press `<leader>` and wait to see which-key popup with available commands
- Use `:checkhealth` to diagnose issues
- Use `:Tutor` for Vim basics tutorial
