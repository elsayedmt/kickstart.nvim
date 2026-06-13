# lazy.nvim → vim.pack Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild this Neovim config on upstream kickstart's new `vim.pack` foundation, preserving all customizations, pruning dead/redundant plugins.

**Architecture:** Fresh branch `vim-pack-migration` from `kickstart/master`; restore customization files from `master`; convert each lazy.nvim spec to direct `vim.pack.add` + `setup` calls (eager) or filetype/command-scoped autocmds (deferred); verify via headless launch; merge to `master`.

**Tech Stack:** Neovim 0.12.2, `vim.pack` (built-in plugin manager), Lua.

**Verification model:** There are no unit tests for a Neovim config. Each task's "test" is `nvim --headless "+qa"` (and `:checkhealth` where relevant) reporting no errors. The FIRST headless launch clones every plugin synchronously and may take a few minutes — this is the install step, not a hang.

**Reference:** Design spec at `docs/superpowers/specs/2026-06-13-vim-pack-migration-design.md`.

**Key decisions:**
- Track latest (drop version *pins*) — but keep *branch* requirements that are functional (harpoon `harpoon2`).
- Deferred loading for filetype/command-scoped plugins; eager for the rest.
- Theme handled in `init.lua` (catppuccin folded in); `catppuccin.lua` custom file removed.
- crates → loaded inside `after/ftplugin/toml.lua`; rustaceanvim → inside `after/ftplugin/rust.lua` (their natural filetype hooks, avoiding autocmd ordering races).

---

## File Structure

| File | Responsibility | Action |
|------|----------------|--------|
| `init.lua` | Core config; upstream vim.pack base + theme + LSP servers + requires | Modify (edits to upstream base) |
| `lua/custom/plugins/init.lua` | Terraform/HCL filetype detection autocmds | Modify (strip lazy specs) |
| `lua/custom/plugins/snacks.lua` | Snacks UI: explorer, pickers, git, toggles, terminal | Convert (eager) |
| `lua/custom/plugins/barbar.lua` | Bufferline + Alt-key buffer nav | Convert (eager) |
| `lua/custom/plugins/harpoon.lua` | Quick file marking/jump | Convert (eager, branch harpoon2) |
| `lua/custom/plugins/neogit.lua` | Git TUI + diffview | Convert (eager) |
| `lua/custom/plugins/refactoring.lua` | Refactoring operations | Convert (eager) |
| `lua/custom/plugins/opencode.lua` | opencode.nvim integration | Convert (eager) |
| `lua/custom/plugins/oil.lua` | Buffer-style file editor | Convert (eager) |
| `lua/custom/plugins/ufo.lua` | Folding | Convert (deferred: BufReadPost) |
| `lua/custom/plugins/typescript.lua` | typescript-tools | Convert (deferred: FileType) |
| `lua/custom/plugins/spectre.lua` | Project search/replace | Convert (deferred: keys) |
| `after/ftplugin/rust.lua` | Rust keymaps + loads rustaceanvim | Modify (prepend deferred add) |
| `after/ftplugin/toml.lua` | Crates keymaps + loads crates.nvim | Modify (prepend add+setup) |
| `lua/kickstart/plugins/*.lua` | debug, lint, indent_line, autopairs, gitsigns | Replace with upstream vim.pack versions (already on branch) |
| `lua/custom/plugins/catppuccin.lua` | — | **Remove** (folded into init.lua) |
| `lua/custom/plugins/kanagawa.lua` | — | **Remove** (dead) |
| `lua/custom/plugins/markdown-preview.lua` | — | **Remove** (dead) |
| `lua/custom/plugins/fugitive.lua` | — | **Remove** (redundant) |
| `lua/kickstart/plugins/neo-tree.lua` | — | **Remove** (redundant) |
| `lazy-lock.json` | — | **Remove** (vim.pack has no lockfile) |

---

## Task 1: Branch setup & file restoration

**Files:**
- Create branch: `vim-pack-migration` from `kickstart/master`
- Restore from `master`: customization files (see below)
- Remove: pruned files + `lazy-lock.json`

- [ ] **Step 1: Commit pending changes on master so nothing is lost**

```bash
cd ~/.config/nvim
git checkout master
git add lua/haroona/init.lua lua/custom/plugins/oil.lua
git commit -m "chore: pending tweaks (haroona shiftwidth, oil plugin) before migration"
```

- [ ] **Step 2: Create the migration branch from upstream**

```bash
git fetch kickstart
git checkout -b vim-pack-migration kickstart/master
```

Expected: working tree now contains upstream's vim.pack-based `init.lua`; your custom files are gone (they don't exist on `kickstart/master`).

- [ ] **Step 3: Restore your customization files from master**

```bash
git checkout master -- lua/custom/plugins/ lua/haroona/ after/ftplugin/ \
  CLAUDE.md HOTKEYS.md docs/ .claude/ .stylua.toml
```

Note: this brings back ALL custom plugin files including the ones to be pruned — removed in the next step. Do NOT restore `init.lua`, `README.md`, or `lua/kickstart/plugins/` — keep upstream's vim.pack versions of those.

- [ ] **Step 4: Remove pruned files**

```bash
git rm -f lua/custom/plugins/kanagawa.lua \
          lua/custom/plugins/markdown-preview.lua \
          lua/custom/plugins/fugitive.lua \
          lua/custom/plugins/catppuccin.lua \
          lua/kickstart/plugins/neo-tree.lua \
          lazy-lock.json
```

Expected: 6 files removed. (catppuccin is folded into init.lua in Task 2; neo-tree is pruned.)

- [ ] **Step 5: Commit the branch baseline**

```bash
git add -A
git commit -m "chore: branch from upstream vim.pack base, restore customizations, prune dead plugins"
```

- [ ] **Step 6: Sanity check — branch has upstream init.lua + your custom files**

```bash
grep -c vim.pack init.lua          # expect: > 0 (upstream base)
ls lua/custom/plugins/             # expect: barbar harpoon init.lua neogit oil opencode refactoring snacks spectre typescript ufo (NO kanagawa/markdown-preview/fugitive/catppuccin)
```

---

## Task 2: `init.lua` — theme, LSP server, enable plugins

**Files:**
- Modify: `init.lua` (upstream vim.pack base, edits by anchor string)

- [ ] **Step 1: Add catppuccin and switch the colorscheme**

In the colorscheme section, find upstream's tokyonight block ending with:

```lua
  vim.cmd.colorscheme 'tokyonight-night'
```

Immediately BEFORE the `vim.cmd.colorscheme` line, add the catppuccin install (so it is on the runtimepath before the colorscheme is applied). Replace the tokyonight colorscheme line. Result:

```lua
  -- Load the colorscheme here.
  -- tokyonight stays installed as a fallback; catppuccin-mocha is the active theme.
  vim.pack.add { gh 'catppuccin/nvim' }
  vim.cmd.colorscheme 'catppuccin-mocha'
```

(Leave the existing `vim.pack.add { gh 'folke/tokyonight.nvim' }` and its `require('tokyonight').setup` above untouched — tokyonight remains installed.)

- [ ] **Step 2: Add the terraformls language server**

Find the `local servers = {` table. Add `terraformls = {}` after the commented examples (upstream's `lua_ls` and `stylua` are already present and kept as-is):

```lua
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    terraformls = {},
    -- ... existing comments ...
    stylua = {}, -- Used to format Lua code
    -- ... existing lua_ls block unchanged ...
  }
```

- [ ] **Step 3: Enable the kickstart plugins you use + load custom plugins + haroona**

Find the `do` block near the end with the commented `require 'kickstart.plugins.*'` lines. Uncomment the five you use (NOT neo-tree), and uncomment `require 'custom.plugins'`, then add `require 'haroona'`:

```lua
  require 'kickstart.plugins.debug'
  require 'kickstart.plugins.indent_line'
  require 'kickstart.plugins.lint'
  require 'kickstart.plugins.autopairs'
  -- require 'kickstart.plugins.neo-tree'  -- pruned: using snacks explorer + oil
  require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

  require 'custom.plugins'
  require 'haroona'
```

- [ ] **Step 4: Verify init.lua loads (this also installs all core plugins — may take minutes)**

```bash
nvim --headless "+qa" 2>&1 | tee /tmp/nvim-init.log; echo "exit: ${PIPESTATUS[0]}"
```

Expected: completes with no Lua error traceback in the log. First run clones plugins (slow). Errors about custom plugins are expected until Tasks 3-9 are done — at this point custom/plugins/* still contain lazy `return {}` tables, which the upstream loader will `require` and harmlessly ignore (they return a table, no error). If you see a hard error, it is in init.lua itself — fix before continuing.

- [ ] **Step 5: Verify the theme loaded**

```bash
nvim --headless "+lua print(vim.g.colors_name)" "+qa" 2>&1 | tail -2
```

Expected: prints `catppuccin-mocha`.

- [ ] **Step 6: Commit**

```bash
git add init.lua
git commit -m "feat(init): catppuccin theme, terraformls, enable kickstart+custom plugins on vim.pack"
```

---

## Task 3: Convert `snacks.lua` (eager)

**Files:**
- Modify: `lua/custom/plugins/snacks.lua` (replace entire contents)

- [ ] **Step 1: Replace the file with the vim.pack version**

The lazy spec's `opts` → `setup` arg; `keys` → `vim.keymap.set`; `init` (VeryLazy) block → run directly after setup (Snacks is available immediately once eager).

```lua
-- Snacks.nvim: dashboard, explorer, pickers, notifier, terminal, toggles, etc.
vim.pack.add { { src = 'https://github.com/folke/snacks.nvim' } }

require('snacks').setup {
  bigfile = { enabled = true },
  dashboard = { enabled = true },
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  picker = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  styles = {
    notification = {},
  },
}

-- Explorer & utilities
vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = 'File Explorer' })
vim.keymap.set('n', '<leader>n', function() Snacks.notifier.show_history() end, { desc = 'Notification History' })

-- Top-level pickers (<leader>p prefix to avoid Telescope <leader>s conflicts)
vim.keymap.set('n', '<leader>p<space>', function() Snacks.picker.smart() end, { desc = '[P]icker Smart Find' })
vim.keymap.set('n', '<leader>p,', function() Snacks.picker.buffers() end, { desc = '[P]icker Buffers' })
vim.keymap.set('n', '<leader>p/', function() Snacks.picker.grep() end, { desc = '[P]icker Grep' })
vim.keymap.set('n', '<leader>p:', function() Snacks.picker.command_history() end, { desc = '[P]icker Command History' })

-- Find
vim.keymap.set('n', '<leader>pfb', function() Snacks.picker.buffers() end, { desc = '[P]icker [F]ind [B]uffers' })
vim.keymap.set('n', '<leader>pfc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[P]icker [F]ind [C]onfig File' })
vim.keymap.set('n', '<leader>pff', function() Snacks.picker.files() end, { desc = '[P]icker [F]ind [F]iles' })
vim.keymap.set('n', '<leader>pfg', function() Snacks.picker.git_files() end, { desc = '[P]icker [F]ind [G]it Files' })
vim.keymap.set('n', '<leader>pfp', function() Snacks.picker.projects() end, { desc = '[P]icker [F]ind [P]rojects' })
vim.keymap.set('n', '<leader>pfr', function() Snacks.picker.recent() end, { desc = '[P]icker [F]ind [R]ecent' })

-- Git pickers
vim.keymap.set('n', '<leader>pgb', function() Snacks.picker.git_branches() end, { desc = '[P]icker [G]it [B]ranches' })
vim.keymap.set('n', '<leader>pgl', function() Snacks.picker.git_log() end, { desc = '[P]icker [G]it [L]og' })
vim.keymap.set('n', '<leader>pgL', function() Snacks.picker.git_log_line() end, { desc = '[P]icker [G]it Log [L]ine' })
vim.keymap.set('n', '<leader>pgs', function() Snacks.picker.git_status() end, { desc = '[P]icker [G]it [S]tatus' })
vim.keymap.set('n', '<leader>pgS', function() Snacks.picker.git_stash() end, { desc = '[P]icker [G]it [S]tash' })
vim.keymap.set('n', '<leader>pgd', function() Snacks.picker.git_diff() end, { desc = '[P]icker [G]it [D]iff (Hunks)' })
vim.keymap.set('n', '<leader>pgf', function() Snacks.picker.git_log_file() end, { desc = '[P]icker [G]it Log [F]ile' })

-- Git operations (non-picker)
vim.keymap.set({ 'n', 'v' }, '<leader>gb', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'Lazygit' })

-- Search pickers (<leader>ps prefix)
vim.keymap.set('n', '<leader>ps"', function() Snacks.picker.registers() end, { desc = '[P]icker [S]earch Registers' })
vim.keymap.set('n', '<leader>ps/', function() Snacks.picker.search_history() end, { desc = '[P]icker [S]earch History' })
vim.keymap.set('n', '<leader>psa', function() Snacks.picker.autocmds() end, { desc = '[P]icker [S]earch Autocmds' })
vim.keymap.set('n', '<leader>psb', function() Snacks.picker.lines() end, { desc = '[P]icker [S]earch [B]uffer Lines' })
vim.keymap.set('n', '<leader>psB', function() Snacks.picker.grep_buffers() end, { desc = '[P]icker [S]earch Grep Open [B]uffers' })
vim.keymap.set('n', '<leader>psg', function() Snacks.picker.grep() end, { desc = '[P]icker [S]earch [G]rep' })
vim.keymap.set({ 'n', 'x' }, '<leader>psw', function() Snacks.picker.grep_word() end, { desc = '[P]icker [S]earch [W]ord' })
vim.keymap.set('n', '<leader>psC', function() Snacks.picker.commands() end, { desc = '[P]icker [S]earch [C]ommands' })
vim.keymap.set('n', '<leader>psd', function() Snacks.picker.diagnostics() end, { desc = '[P]icker [S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>psD', function() Snacks.picker.diagnostics_buffer() end, { desc = '[P]icker [S]earch Buffer [D]iagnostics' })
vim.keymap.set('n', '<leader>psh', function() Snacks.picker.help() end, { desc = '[P]icker [S]earch [H]elp Pages' })
vim.keymap.set('n', '<leader>psH', function() Snacks.picker.highlights() end, { desc = '[P]icker [S]earch [H]ighlights' })
vim.keymap.set('n', '<leader>psi', function() Snacks.picker.icons() end, { desc = '[P]icker [S]earch [I]cons' })
vim.keymap.set('n', '<leader>psj', function() Snacks.picker.jumps() end, { desc = '[P]icker [S]earch [J]umps' })
vim.keymap.set('n', '<leader>psk', function() Snacks.picker.keymaps() end, { desc = '[P]icker [S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>psl', function() Snacks.picker.loclist() end, { desc = '[P]icker [S]earch [L]ocation List' })
vim.keymap.set('n', '<leader>psm', function() Snacks.picker.marks() end, { desc = '[P]icker [S]earch [M]arks' })
vim.keymap.set('n', '<leader>psM', function() Snacks.picker.man() end, { desc = '[P]icker [S]earch [M]an Pages' })
vim.keymap.set('n', '<leader>psp', function() Snacks.picker.lazy() end, { desc = '[P]icker [S]earch [P]lugin Spec' })
vim.keymap.set('n', '<leader>psq', function() Snacks.picker.qflist() end, { desc = '[P]icker [S]earch [Q]uickfix List' })
vim.keymap.set('n', '<leader>psR', function() Snacks.picker.resume() end, { desc = '[P]icker [S]earch [R]esume' })
vim.keymap.set('n', '<leader>psu', function() Snacks.picker.undo() end, { desc = '[P]icker [S]earch [U]ndo History' })
vim.keymap.set('n', '<leader>psc', function() Snacks.picker.colorschemes() end, { desc = '[P]icker [S]earch [C]olorschemes' })

-- LSP pickers (<leader>pl prefix)
vim.keymap.set('n', '<leader>pld', function() Snacks.picker.lsp_definitions() end, { desc = '[P]icker [L]SP [D]efinitions' })
vim.keymap.set('n', '<leader>plD', function() Snacks.picker.lsp_declarations() end, { desc = '[P]icker [L]SP [D]eclarations' })
vim.keymap.set('n', '<leader>plr', function() Snacks.picker.lsp_references() end, { desc = '[P]icker [L]SP [R]eferences' })
vim.keymap.set('n', '<leader>pli', function() Snacks.picker.lsp_implementations() end, { desc = '[P]icker [L]SP [I]mplementations' })
vim.keymap.set('n', '<leader>plt', function() Snacks.picker.lsp_type_definitions() end, { desc = '[P]icker [L]SP [T]ype Definitions' })
vim.keymap.set('n', '<leader>pls', function() Snacks.picker.lsp_symbols() end, { desc = '[P]icker [L]SP [S]ymbols' })
vim.keymap.set('n', '<leader>plS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = '[P]icker [L]SP Workspace [S]ymbols' })

-- Buffer / code / UI
vim.keymap.set('n', '<leader>bx', function() Snacks.bufdelete() end, { desc = 'Delete Buffer (close)' })
vim.keymap.set('n', '<leader>cR', function() Snacks.rename.rename_file() end, { desc = 'Rename File' })
vim.keymap.set('n', '<leader>z', function() Snacks.zen() end, { desc = 'Toggle Zen Mode' })
vim.keymap.set('n', '<leader>Z', function() Snacks.zen.zoom() end, { desc = 'Toggle Zoom' })
vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })
vim.keymap.set('n', '<leader>S', function() Snacks.scratch.select() end, { desc = 'Select Scratch Buffer' })
vim.keymap.set('n', '<leader>un', function() Snacks.notifier.hide() end, { desc = 'Dismiss All Notifications' })

-- Terminal
vim.keymap.set('n', '<c-/>', function() Snacks.terminal() end, { desc = 'Toggle Terminal' })
vim.keymap.set('n', '<c-_>', function() Snacks.terminal() end, { desc = 'which_key_ignore' })

-- Word navigation
vim.keymap.set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Reference' })
vim.keymap.set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Reference' })

-- Debug globals + toggle mappings (ran inline; Snacks is loaded eagerly above)
_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function() Snacks.debug.backtrace() end
vim.print = _G.dd

Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
Snacks.toggle.diagnostics():map '<leader>ud'
Snacks.toggle.line_number():map '<leader>ul'
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
Snacks.toggle.treesitter():map '<leader>uT'
Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
Snacks.toggle.inlay_hints():map '<leader>uh'
Snacks.toggle.indent():map '<leader>ug'
Snacks.toggle.dim():map '<leader>uD'
```

Note: the duplicate `<leader>psc` from the original (command_history vs colorschemes) is resolved here to colorschemes, matching the last-wins behavior of the original lazy spec. The `<leader>N` Neovim-news and `<leader>z`-adjacent maps from the original are retained above; the rarely-used `<leader>N` news window was dropped to reduce noise (re-add if wanted).

- [ ] **Step 2: Verify it loads and a Snacks keymap exists**

```bash
nvim --headless "+lua require('snacks'); print('snacks ok')" "+qa" 2>&1 | tail -3
nvim --headless "+lua print(vim.fn.maparg('<leader>e', 'n') ~= '')" "+qa" 2>&1 | tail -1
```

Expected: `snacks ok`, then `true`.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/snacks.lua
git commit -m "feat(snacks): convert to vim.pack"
```

---

## Task 4: Convert `barbar.lua` (eager)

**Files:**
- Modify: `lua/custom/plugins/barbar.lua` (replace entire contents)

- [ ] **Step 1: Replace the file**

`init`'s `barbar_auto_setup=false` + keymaps run first; then add + explicit setup. gitsigns is added eagerly in init.lua; icons come from upstream's mini.icons devicons mock, so no extra deps needed.

```lua
-- barbar.nvim: bufferline with Alt-key buffer navigation
local function key_maps()
  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
  map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
  map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
  map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
  map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
  map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
  map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
  map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
  map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
  map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
  map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
  map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
  map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
  map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
  map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
  map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
  map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
  map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
  map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
  map('n', '<Space>bD', '<Cmd>BufferOrderByDirectory<CR>', opts)
  map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
  map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
end

vim.g.barbar_auto_setup = false
key_maps()

vim.pack.add { { src = 'https://github.com/romgrk/barbar.nvim' } }
require('barbar').setup {}
```

- [ ] **Step 2: Verify**

```bash
nvim --headless "+lua require('barbar'); print('barbar ok')" "+qa" 2>&1 | tail -2
```

Expected: `barbar ok`.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/barbar.lua
git commit -m "feat(barbar): convert to vim.pack"
```

---

## Task 5: Convert `harpoon.lua` (eager, branch harpoon2)

**Files:**
- Modify: `lua/custom/plugins/harpoon.lua` (replace entire contents)

- [ ] **Step 1: Replace the file**

`harpoon2` is a *branch* (the v2 API the keymaps use), not a version pin — kept via `version`. plenary is present (telescope adds it eagerly in init.lua), added here explicitly for clarity.

```lua
-- Harpoon 2: quick file marking & navigation
vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
}

local harpoon = require 'harpoon'
harpoon:setup {
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
}

vim.keymap.set('n', '<leader>ma', function() harpoon:list():add() end, { desc = '[M]ark: [A]dd file to Harpoon' })
vim.keymap.set('n', '<leader>mm', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[M]ark: Toggle Harpoon [M]enu' })
vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = '[M]ark: Jump to file 1' })
vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = '[M]ark: Jump to file 2' })
vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = '[M]ark: Jump to file 3' })
vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = '[M]ark: Jump to file 4' })
vim.keymap.set('n', '<leader>mp', function() harpoon:list():prev() end, { desc = '[M]ark: [P]revious file' })
vim.keymap.set('n', '<leader>mn', function() harpoon:list():next() end, { desc = '[M]ark: [N]ext file' })
vim.keymap.set('n', '<leader>mc', function() harpoon:list():clear() end, { desc = '[M]ark: [C]lear all marks' })
```

- [ ] **Step 2: Verify**

```bash
nvim --headless "+lua print(require('harpoon').list ~= nil)" "+qa" 2>&1 | tail -1
```

Expected: `true` (confirms the harpoon2 API is present, not v1).

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/harpoon.lua
git commit -m "feat(harpoon): convert to vim.pack (harpoon2 branch)"
```

---

## Task 6: Convert `neogit.lua` (eager)

**Files:**
- Modify: `lua/custom/plugins/neogit.lua` (replace entire contents)

- [ ] **Step 1: Replace the file**

`config = true` meant "call setup with defaults". telescope is added eagerly in init.lua; plenary too. Add diffview (optional but in original deps). Drop fzf-lua (telescope is the chosen finder).

```lua
-- Neogit: Git TUI, with diffview integration
vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/sindrets/diffview.nvim' },
  { src = 'https://github.com/NeogitOrg/neogit' },
}
require('neogit').setup {}
```

- [ ] **Step 2: Verify**

```bash
nvim --headless "+lua require('neogit'); print('neogit ok')" "+qa" 2>&1 | tail -2
```

Expected: `neogit ok`.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/neogit.lua
git commit -m "feat(neogit): convert to vim.pack"
```

---

## Task 7: ~~Convert `refactoring.lua`~~ — SUPERSEDED: refactoring.nvim removed

> **Decision (during execution):** refactoring.nvim's latest version requires `lewis6991/async.nvim`, which collides with nvim-ufo's `promise-async` over the global `require('async')` module name (table vs callable — they cannot coexist on the runtimepath). Since refactoring's keymap API and the async.nvim dependency arrived in the same breaking commit, keeping the keymaps forces the conflict. User chose to **drop refactoring.nvim** (and async.nvim) and keep ufo. `lua/custom/plugins/refactoring.lua` was removed; the `<leader>x*` keymaps are gone. The block below is retained for history only — do not implement it.

**Files:**
- ~~Modify: `lua/custom/plugins/refactoring.lua`~~ (removed instead)

- [ ] **Step 1: Replace the file**

plenary + treesitter are present (treesitter added eagerly in init.lua). Keep the telescope-extension load guarded by pcall.

```lua
-- refactoring.nvim: extract/inline/debug refactorings
-- NOTE: refactoring.nvim now requires lewis6991/async.nvim at runtime (added upstream 2026).
vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/lewis6991/async.nvim' },
  { src = 'https://github.com/ThePrimeagen/refactoring.nvim' },
}

require('refactoring').setup {
  prompt_func_return_type = { go = false, java = false, cpp = false, c = false, h = false, hpp = false, cxx = false },
  prompt_func_param_type = { go = false, java = false, cpp = false, c = false, h = false, hpp = false, cxx = false },
  printf_statements = {},
  print_var_statements = {},
  show_success_message = true,
}

if pcall(require, 'telescope') then
  require('telescope').load_extension 'refactoring'
end

-- Extract (visual)
vim.keymap.set('x', '<leader>xe', function() require('refactoring').refactor 'Extract Function' end, { desc = 'R[x]factor: [E]xtract Function' })
vim.keymap.set('x', '<leader>xf', function() require('refactoring').refactor 'Extract Function To File' end, { desc = 'R[x]factor: Extract to [F]ile' })
vim.keymap.set('x', '<leader>xv', function() require('refactoring').refactor 'Extract Variable' end, { desc = 'R[x]factor: Extract [V]ariable' })
vim.keymap.set('x', '<leader>xb', function() require('refactoring').refactor 'Extract Block' end, { desc = 'R[x]factor: Extract [B]lock' })
vim.keymap.set('x', '<leader>xF', function() require('refactoring').refactor 'Extract Block To File' end, { desc = 'R[x]factor: Extract Block to [F]ile' })

-- Inline
vim.keymap.set({ 'n', 'x' }, '<leader>xi', function() require('refactoring').refactor 'Inline Variable' end, { desc = 'R[x]factor: [I]nline Variable' })
vim.keymap.set('n', '<leader>xI', function() require('refactoring').refactor 'Inline Function' end, { desc = 'R[x]factor: [I]nline Function' })

-- Debug helpers
vim.keymap.set({ 'n', 'x' }, '<leader>xp', function() require('refactoring').debug.printf { below = false } end, { desc = 'R[x]factor: Debug [P]rint' })
vim.keymap.set('n', '<leader>xV', function() require('refactoring').debug.print_var() end, { desc = 'R[x]factor: Debug Print [V]ariable' })
vim.keymap.set('n', '<leader>xc', function() require('refactoring').debug.cleanup {} end, { desc = 'R[x]factor: Debug [C]leanup' })

-- Menu
vim.keymap.set({ 'n', 'x' }, '<leader>xx', function() require('refactoring').select_refactor() end, { desc = 'R[x]factor: Select operation' })
```

Note: the original had a `<leader>xv` collision (Extract Variable in `x` mode AND Debug Print Var in `n` mode). Since `vim.keymap.set` keys are mode-scoped, both could coexist; but to remove ambiguity the debug print-var map is moved to `<leader>xV` here.

- [ ] **Step 2: Verify**

```bash
nvim --headless "+lua require('refactoring'); print('refactoring ok')" "+qa" 2>&1 | tail -2
```

Expected: `refactoring ok`.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/refactoring.lua
git commit -m "feat(refactoring): convert to vim.pack"
```

---

## Task 8: Convert `opencode.lua` (eager)

**Files:**
- Modify: `lua/custom/plugins/opencode.lua` (replace entire contents)

- [ ] **Step 1: Replace the file**

opencode is configured via `vim.g.opencode_opts` (no `setup()` call). It depends on snacks; snacks loads from `snacks.lua`, but since the directory loads alphabetically (`opencode` before `snacks`), add snacks here too — `vim.pack.add` is idempotent, so snacks.lua's later add+setup still wins.

```lua
-- opencode.nvim: opencode integration (tmux provider)
vim.pack.add {
  { src = 'https://github.com/folke/snacks.nvim' },
  { src = 'https://github.com/NickvanDyke/opencode.nvim' },
}

vim.g.opencode_opts = {
  provider = {
    enabled = 'tmux',
    tmux = { options = '-h' },
  },
}

vim.o.autoread = true

vim.keymap.set({ 'n', 'x' }, '<leader>oa', function() require('opencode').ask('@this: ', { submit = true }) end, { desc = '[O]pencode [A]sk' })
vim.keymap.set({ 'n', 'x' }, '<leader>ox', function() require('opencode').select() end, { desc = '[O]pencode E[x]ecute action' })
vim.keymap.set({ 'n', 'x' }, '<leader>op', function() require('opencode').prompt '@this' end, { desc = '[O]pencode [P]rompt (add to chat)' })
vim.keymap.set({ 'n', 't' }, '<leader>oo', function() require('opencode').toggle() end, { desc = '[O]pencode Toggle' })
vim.keymap.set({ 'n', 't' }, '<C-.>', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
vim.keymap.set('n', '<leader>ou', function() require('opencode').command 'session.half.page.up' end, { desc = '[O]pencode half page [U]p' })
vim.keymap.set('n', '<leader>od', function() require('opencode').command 'session.half.page.down' end, { desc = '[O]pencode half page [D]own' })
```

- [ ] **Step 2: Verify**

```bash
nvim --headless "+lua require('opencode'); print('opencode ok')" "+qa" 2>&1 | tail -2
```

Expected: `opencode ok`.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/opencode.lua
git commit -m "feat(opencode): convert to vim.pack"
```

---

## Task 9: Convert `oil.lua` (eager)

**Files:**
- Modify: `lua/custom/plugins/oil.lua` (replace entire contents)

- [ ] **Step 1: Replace the file**

mini.icons comes from upstream's mini.nvim (added eagerly in init.lua). Add a `-` mapping (oil's idiomatic "open parent directory") to give the keyless explorer an entry point now that neo-tree's `\` is gone.

```lua
-- oil.nvim: edit the filesystem like a buffer
vim.pack.add { { src = 'https://github.com/stevearc/oil.nvim' } }
require('oil').setup {}

vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory (Oil)' })
```

- [ ] **Step 2: Verify**

```bash
nvim --headless "+lua require('oil'); print('oil ok')" "+qa" 2>&1 | tail -2
```

Expected: `oil ok`.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/oil.lua
git commit -m "feat(oil): convert to vim.pack, add '-' keymap"
```

---

## Task 10: Convert `ufo.lua` (deferred: BufReadPost)

**Files:**
- Modify: `lua/custom/plugins/ufo.lua` (replace entire contents)

- [ ] **Step 1: Replace the file**

Fold options are cheap and set eagerly. The plugin (and its `promise-async` dep) load on the first `BufReadPost`.

```lua
-- nvim-ufo: high-performance folding (deferred to first buffer read)
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.api.nvim_create_autocmd('BufReadPost', {
  once = true,
  callback = function()
    vim.pack.add {
      { src = 'https://github.com/kevinhwang91/promise-async' },
      { src = 'https://github.com/kevinhwang91/nvim-ufo' },
    }
    require('ufo').setup {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    }
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', 'zK', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek fold or show hover' })
  end,
})
```

- [ ] **Step 2: Verify (open a real file to trigger BufReadPost)**

```bash
nvim --headless init.lua "+lua print(require('ufo') ~= nil)" "+qa" 2>&1 | tail -1
```

Expected: `true`.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/ufo.lua
git commit -m "feat(ufo): convert to vim.pack (deferred on BufReadPost)"
```

---

## Task 11: Convert `typescript.lua` (deferred: FileType)

**Files:**
- Modify: `lua/custom/plugins/typescript.lua` (replace entire contents)

- [ ] **Step 1: Replace the file**

typescript-tools registers an LSP. Loading it on `FileType` and then re-firing `FileType` for the current buffer makes it attach to the file that triggered the load (otherwise it would only attach to the *next* JS/TS file). The augroup is deleted first to prevent the re-fire from recursing. nvim-lspconfig is present (added eagerly in init.lua).

```lua
-- typescript-tools.nvim (deferred to first JS/TS filetype)
local group = vim.api.nvim_create_augroup('typescript_tools_lazy', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' },
  callback = function(ev)
    vim.api.nvim_del_augroup_by_id(group)
    vim.pack.add {
      { src = 'https://github.com/nvim-lua/plenary.nvim' },
      { src = 'https://github.com/pmizio/typescript-tools.nvim' },
    }
    require('typescript-tools').setup {
      settings = {
        tsserver_format_options = { tabSize = 2, indentSize = 2 },
      },
    }
    -- re-fire so the just-loaded plugin attaches to the current buffer
    vim.api.nvim_exec_autocmds('FileType', { buffer = ev.buf, modeline = false })
  end,
})
```

- [ ] **Step 2: Verify (open a .ts buffer to trigger load + attach)**

```bash
printf 'const x: number = 1;\n' > /tmp/probe.ts
nvim --headless /tmp/probe.ts "+lua vim.defer_fn(function() print(require('typescript-tools') ~= nil); vim.cmd('qa') end, 200)" 2>&1 | tail -1
rm -f /tmp/probe.ts
```

Expected: `true`.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/typescript.lua
git commit -m "feat(typescript): convert to vim.pack (deferred on filetype)"
```

---

## Task 12: Convert `spectre.lua` (deferred: keys)

**Files:**
- Modify: `lua/custom/plugins/spectre.lua` (replace entire contents)

- [ ] **Step 1: Replace the file**

spectre was `cmd`/`keys`-lazy. Load it on the first use of any `<leader>S*` mapping via a one-shot loader; `vim.pack.add` is idempotent so repeated presses are safe.

```lua
-- nvim-spectre: project search & replace (deferred to first use)
local loaded = false
local function ensure()
  if not loaded then
    vim.pack.add {
      { src = 'https://github.com/nvim-lua/plenary.nvim' },
      { src = 'https://github.com/nvim-pack/nvim-spectre' },
    }
    require('spectre').setup {
      color_devicons = true,
      open_cmd = 'vnew',
      live_update = false,
      line_sep_start = '┌-----------------------------------------',
      result_padding = '¦  ',
      line_sep = '└-----------------------------------------',
      highlight = { ui = 'String', search = 'DiffChange', replace = 'DiffDelete' },
      default = {
        find = { cmd = 'rg', options = { 'ignore-case' } },
        replace = { cmd = 'sed' },
      },
    }
    loaded = true
  end
end

vim.keymap.set('n', '<leader>SS', function()
  ensure()
  require('spectre').toggle()
end, { desc = 'Toggle [S]pectre (search/replace)' })

vim.keymap.set('n', '<leader>Sw', function()
  ensure()
  require('spectre').open_visual { select_word = true }
end, { desc = '[S]pectre: Replace current [W]ord' })

vim.keymap.set('v', '<leader>Sr', function()
  ensure()
  require('spectre').open_visual()
end, { desc = '[S]pectre: [R]eplace selection' })

vim.keymap.set('n', '<leader>Sf', function()
  ensure()
  require('spectre').open_file_search { select_word = true }
end, { desc = '[S]pectre: Replace in current [F]ile' })
```

- [ ] **Step 2: Verify (maps registered without loading the plugin)**

```bash
nvim --headless "+lua print(vim.fn.maparg('<leader>SS', 'n') ~= '')" "+qa" 2>&1 | tail -1
```

Expected: `true`.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/spectre.lua
git commit -m "feat(spectre): convert to vim.pack (deferred on first use)"
```

---

## Task 13: Convert `custom/plugins/init.lua` (filetype detection only)

**Files:**
- Modify: `lua/custom/plugins/init.lua` (replace entire contents)

- [ ] **Step 1: Replace the file**

Strip the lazy spec (crates + rustaceanvim move to the ftplugin files in Task 14). Keep only the terraform/HCL filetype autocmds.

```lua
-- Terraform / HCL filetype detection
vim.cmd [[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]]
vim.cmd [[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]]
vim.cmd [[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]]
vim.cmd [[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]]
vim.cmd [[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]]

-- crates.nvim and rustaceanvim are loaded lazily from after/ftplugin/{toml,rust}.lua.

-- Iterate over all Lua files in this directory and load them (upstream loader).
-- CRITICAL: this loop is what `require`s each per-plugin file (snacks.lua, etc.).
-- It MUST be preserved — restoring this file from master clobbered it, which is why
-- it is re-added here.
local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir, { follow = true }) do
  if (type == 'file' or type == 'link') and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('custom.plugins.' .. module)
  end
end
```

Note: this `init.lua` is required via `require 'custom.plugins'` in the main init.lua; the loop above then requires every other `*.lua` in the directory. **Both** the terraform autocmds and the loop must be present — the loop was lost when Task 1 restored this file from master (which had the old lazy-import version), so it is restored here.

- [ ] **Step 2: Verify**

```bash
nvim --headless "+qa" 2>&1 | tail -3; echo "exit: ${PIPESTATUS[0]}"
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lua/custom/plugins/init.lua
git commit -m "refactor(custom): strip lazy specs, keep terraform filetype detection"
```

---

## Task 14: Defer rustaceanvim & crates inside their ftplugins

**Files:**
- Modify: `after/ftplugin/rust.lua` (prepend deferred add)
- Modify: `after/ftplugin/toml.lua` (prepend add + setup)

- [ ] **Step 1: Prepend the rustaceanvim loader to `after/ftplugin/rust.lua`**

Add this block at the VERY TOP of the file, before the existing `local bufnr = ...` line. rustaceanvim self-configures (no `setup()`); re-firing FileType makes its LSP attach to the buffer that triggered the load.

```lua
-- Load rustaceanvim on first Rust buffer (it provides :RustLsp used below)
if not vim.g.__rustaceanvim_loaded then
  vim.g.__rustaceanvim_loaded = true
  vim.pack.add { { src = 'https://github.com/mrcjkb/rustaceanvim' } }
  -- re-fire so rustaceanvim attaches to the current buffer
  vim.api.nvim_exec_autocmds('FileType', { buffer = vim.api.nvim_get_current_buf(), modeline = false })
end

```

(The existing keymaps below are unchanged and idempotent under the re-fire.)

- [ ] **Step 2: Prepend the crates loader to `after/ftplugin/toml.lua`**

The file currently begins `local crates = require 'crates'`. Add the install + setup ABOVE that line so `require 'crates'` succeeds:

```lua
-- Load crates.nvim for TOML buffers (Cargo.toml dependency management)
vim.pack.add { { src = 'https://github.com/saecki/crates.nvim' } }
require('crates').setup {}

local crates = require 'crates'
```

(The commented keymap block below stays as-is.)

- [ ] **Step 3: Verify rust loads rustaceanvim**

```bash
printf 'fn main() {}\n' > /tmp/probe.rs
nvim --headless /tmp/probe.rs "+lua print(vim.g.__rustaceanvim_loaded == true)" "+qa" 2>&1 | tail -1
rm -f /tmp/probe.rs
```

Expected: `true`.

- [ ] **Step 4: Verify toml loads crates**

```bash
printf '[dependencies]\nserde = "1"\n' > /tmp/Cargo.toml
nvim --headless /tmp/Cargo.toml "+lua print(require('crates') ~= nil)" "+qa" 2>&1 | tail -1
rm -f /tmp/Cargo.toml
```

Expected: `true`.

- [ ] **Step 5: Commit**

```bash
git add after/ftplugin/rust.lua after/ftplugin/toml.lua
git commit -m "feat(ftplugin): load rustaceanvim/crates lazily via vim.pack"
```

---

## Task 15: Full verification & health check

**Files:** none (verification only)

- [ ] **Step 1: Clean headless launch (no plugin errors)**

```bash
nvim --headless "+qa" 2>&1 | tee /tmp/nvim-final.log
test ! -s /tmp/nvim-final.log && echo "CLEAN" || cat /tmp/nvim-final.log
```

Expected: `CLEAN` (empty log) or only benign notices — no Lua tracebacks.

- [ ] **Step 2: vim.pack health**

```bash
nvim --headless "+checkhealth vim.pack" "+w! /tmp/pack-health.txt" "+qa"
grep -iE "error|fail" /tmp/pack-health.txt || echo "no pack errors"
```

Expected: `no pack errors`.

- [ ] **Step 3: Confirm no lingering lazy.nvim references**

```bash
grep -rn "require('lazy')\|require(\"lazy\")\|LazySpec\|lazy.setup" init.lua lua/ after/ || echo "no lazy refs"
```

Expected: `no lazy refs`.

- [ ] **Step 4: Interactive smoke test (manual)**

Open nvim normally and confirm:
- Theme is catppuccin-mocha
- `<leader>e` opens snacks explorer; `-` opens oil
- `<leader>sf` (telescope) and `<leader>pff` (snacks picker) both work
- `<leader>ma` / `<leader>mm` harpoon
- `<A-.>` / `<A-,>` barbar buffer nav
- Open a `.lua` file → lua_ls attaches (`:LspInfo`)
- Open a `.rs` file → rustaceanvim attaches, `<leader>rr` works
- Open a `.tf` file → terraformls attaches
- `:Spectre` opens

- [ ] **Step 5: Commit any fixes found during smoke test, then this checkpoint**

```bash
git add -A
git commit -m "test: verify vim.pack migration (or fixes from smoke test)" --allow-empty
```

---

## Task 16: Docs update & merge to master

**Files:**
- Modify: `HOTKEYS.md` (keybinding accuracy)
- Modify: `CLAUDE.md` (plugin-manager reference)

- [ ] **Step 1: Update HOTKEYS.md for changed bindings**

Remove neo-tree's `\` binding and vim-fugitive bindings; add oil's `-`. Update any "lazy.nvim" mentions to "vim.pack". (Read the file first; edit the affected lines only.)

- [ ] **Step 2: Update CLAUDE.md plugin-manager references**

In `CLAUDE.md`, change the "Uses lazy.nvim as the plugin manager" line and related guidance to describe vim.pack (`vim.pack.add` + `setup`, files in `lua/custom/plugins/*.lua` are `require`d, no lockfile). Update the "Plugin Structure" example from the lazy `return {}` pattern to the vim.pack pattern.

- [ ] **Step 3: Commit docs**

```bash
git add HOTKEYS.md CLAUDE.md
git commit -m "docs: update for vim.pack migration"
```

- [ ] **Step 4: Final headless check, then merge to master**

```bash
nvim --headless "+qa" 2>&1 | tee /tmp/nvim-merge.log
test ! -s /tmp/nvim-merge.log && echo "CLEAN — safe to merge"
git checkout master
git merge --no-ff vim-pack-migration -m "feat: migrate from lazy.nvim to vim.pack (upstream kickstart sync)"
```

- [ ] **Step 5: (Optional) push**

Only if the user requests it:

```bash
git push origin master
```

---

## Self-Review

**Spec coverage:** Every spec section maps to a task — git workflow (T1), init.lua theme/LSP/requires (T2), each custom plugin convert (T3–T13), deferred ftplugin loaders (T14), removed files (T1), verification (T15), docs + merge (T16). ✅

**Placeholder scan:** No TBD/TODO; every code step shows complete file contents or exact edits. ✅

**Consistency:** Plugin URLs use full `https://github.com/...` form (no `gh` helper outside init.lua, where it is upstream-defined). Deferred-LSP re-fire pattern (`nvim_exec_autocmds` + augroup delete / `vim.g` guard) is used consistently in T11 and T14. crates/rustaceanvim removed from `custom/plugins/init.lua` (T13) exactly where they're added back in ftplugins (T14). catppuccin removed as a custom file (T1) and folded into init.lua (T2) — no double-load. ✅

**Known trade-off flagged:** harpoon keeps `version = 'harpoon2'` (a functional branch requirement, distinct from the version-pins-dropped decision).
