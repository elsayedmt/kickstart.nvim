# Migration: lazy.nvim → vim.pack

**Date:** 2026-06-13
**Status:** Approved (design)
**Neovim:** v0.12.2 (vim.pack available)

## Background

Upstream `kickstart.nvim` (remote `kickstart`, `nvim-lua/kickstart.nvim`) made a fundamental
architectural change: it migrated the entire config from **lazy.nvim** to **`vim.pack`**, Neovim
0.12's built-in plugin manager (upstream commit `c460542 "Migrate to vim.pack"`). `init.lua` was
almost entirely rewritten (~1,669 lines changed) and reorganized into sections.

This personal fork is heavily customized (25 commits ahead) and built around lazy.nvim:
`require('lazy').setup({...})` in `init.lua` plus per-plugin `LazySpec` tables in
`lua/custom/plugins/*.lua`. A literal `git rebase kickstart/master` would conflict on nearly every
commit and produce an incoherent result (lazy specs grafted onto a vim.pack base). Instead we do a
deliberate **rebuild on the upstream base**, re-porting customizations.

## Goal

Adopt upstream's vim.pack architecture while preserving this fork's customizations (catppuccin
theme, LSP server set, custom plugins, keybindings), pruning dead/redundant plugins, and keeping
future `kickstart/master` integrations manageable.

## Decisions (locked in)

| Decision | Choice |
|----------|--------|
| Loading model | **Preserve deferred loading** — filetype/command-scoped plugins wrapped in autocmds; everything else eager (kickstart-style) |
| Plugin scope | **Prune as we go** — remove the dead/redundant plugins listed below; port the rest |
| Git strategy | **Fresh rebuild branch** from `kickstart/master`; re-add customizations; `master` is the rollback |
| Versioning | **Track latest** — drop all version pins, follow each plugin's default branch |
| Theme | Keep **catppuccin-mocha** active; tokyonight stays installed as a fallback |

## Architecture

### Git workflow

1. On `master`, commit the two pending changes so nothing is lost:
   - `lua/haroona/init.lua` (shiftwidth 4→2)
   - new untracked `lua/custom/plugins/oil.lua`
2. Create branch `vim-pack-migration` from `kickstart/master` (clean upstream tree).
3. Restore customization files from `master` onto the branch with `git checkout master -- <paths>`:
   - `lua/custom/plugins/` (all)
   - `lua/haroona/`
   - `after/ftplugin/`
   - `CLAUDE.md`, `HOTKEYS.md`, `docs/`, `.claude/`
4. Convert the restored files (see below).
5. Delete `lazy-lock.json` (vim.pack manages its own state; no lockfile equivalent).
6. Verify nvim launches clean, then merge `vim-pack-migration` → `master`.

`master` remains untouched throughout as the rollback point.

### `init.lua`

Base = upstream's new sectioned vim.pack `init.lua`. Re-apply customizations:

- **Colorscheme:** replace upstream's `vim.cmd.colorscheme 'tokyonight-night'` with
  `catppuccin-mocha`; add `vim.pack.add` for `catppuccin/nvim`. Keep tokyonight installed.
- **LSP servers:** port the `servers` table — `terraformls`, the custom `lua_ls` `on_init` block,
  and `stylua`. The fork already uses the modern `vim.lsp.config(name, server)` /
  `vim.lsp.enable(name)` API, identical to upstream, so this drops in without rework.
- **Enabled kickstart plugins:** uncomment requires for `kickstart.plugins.debug`,
  `indent_line`, `lint`, `autopairs`, `gitsigns`. **Not** `neo-tree` (pruned).
- Uncomment `require 'custom.plugins'` and add `require 'haroona'`.
- Adopt upstream's new vim.pack versions of `lua/kickstart/plugins/*.lua`.

### Custom plugin conversion

The new `lua/custom/plugins/init.lua` loader (from upstream) simply `require()`s each `*.lua` file
in the directory — it no longer imports `LazySpec` tables. So each file must call `vim.pack.add` +
`setup` directly instead of returning a spec.

**Eager pattern** (loaded at startup):
```lua
vim.pack.add { { src = 'https://github.com/folke/snacks.nvim' } }
require('snacks').setup { ... }
-- lazy `keys` become plain vim.keymap.set calls
```

**Deferred pattern** (filetype / command / event scoped — preserves fast startup):
```lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust' }, once = true,
  callback = function()
    vim.pack.add { { src = 'https://github.com/mrcjkb/rustaceanvim' } }
    -- rustaceanvim self-configures via vim.g.rustaceanvim
  end,
})
```

Lazy spec field translations:
- `keys` → `vim.keymap.set` (eager) or set inside the deferral callback
- `cmd` → load on first invocation of the user command / first keypress
- `ft` → `FileType` autocmd (`once = true`)
- `event` (e.g. `BufReadPost`) → matching autocmd
- `dependencies` → additional `vim.pack.add` entries (added before the dependent plugin)
- `version` / `tag` / `branch` → **dropped** (track latest, per decision)
- `init` → run before/at add; `config`/`opts` → `require(x).setup(opts)` after add

### Per-plugin plan

**Eager:**
- `snacks.lua` — large; explorer (`<leader>e`), pickers (`<leader>p*`), git, toggles, terminal, words. `priority`/`lazy=false` → just eager add. Port the `init` autocmd (VeryLazy → a startup call or `User`/`VimEnter` autocmd).
- `catppuccin.lua` — add + the colorscheme is set in `init.lua`.
- `barbar.lua` — keep `vim.g.barbar_auto_setup = false`, the Alt-key maps, eager add + setup.
- `harpoon.lua` — eager add; `harpoon:setup{...}`; map `<leader>m*`, `<leader>1..4`.
- `neogit.lua` — eager add (deps: plenary, diffview, telescope); `config = true` → `setup{}`.
- `refactoring.lua` — eager add (deps: plenary, treesitter); setup + telescope extension load; map `<leader>x*`.
- `ufo.lua` — was `event = BufReadPost`; deferred via `BufReadPost` autocmd; set fold options + maps.
- `opencode.lua` — eager add (dep: snacks); set `vim.g.opencode_opts`, `vim.o.autoread`, map `<leader>o*`, `<C-.>`.

**Deferred:**
- `typescript.lua` — `FileType` {typescript, javascript, ...} → add typescript-tools (deps plenary, lspconfig) + setup.
- `spectre.lua` — was `cmd = 'Spectre'` + keys; load on first `<leader>S*` press / `:Spectre`.
- `custom/plugins/init.lua` — keep the terraform/hcl filetype autocmds at top; convert
  `crates.nvim` (toml/Cargo.toml filetype) and `rustaceanvim` (rust filetype) to deferred adds.

**after/ftplugin:** `rust.lua`, `toml.lua` — mostly manager-agnostic; verify they don't depend on
lazy-specific load ordering after the deferral changes.

### Removed

- `lua/custom/plugins/kanagawa.lua` — dead (theme fully commented out).
- `lua/custom/plugins/markdown-preview.lua` — dead (`return {}`, whole spec commented; needs yarn build).
- **neo-tree** — `lua/kickstart/plugins/neo-tree.lua` + its require in `init.lua`. Redundant with
  snacks explorer (`<leader>e`, tree) + oil (buffer-style). The `\` keybind is freed.
- **vim-fugitive** — `lua/custom/plugins/fugitive.lua`. Redundant with neogit+diffview, snacks
  lazygit (`<leader>gg`), and gitsigns. Its current spec was also malformed.

## Verification

1. `nvim --headless "+qa"` — catch load/runtime errors; iterate until clean.
2. `nvim --headless "+checkhealth vim.pack" "+qa"` — confirm plugins installed/healthy.
3. Manual smoke test: catppuccin theme loads; LSP attaches (lua, terraform); telescope (`<leader>s*`)
   and snacks pickers (`<leader>p*`); snacks explorer (`<leader>e`); oil; harpoon (`<leader>m*`);
   barbar Alt-nav; open a `.rs` file → rustaceanvim/crates load; `:Spectre`.
4. Snyk scan: N/A — no first-party application code is introduced (config-only Lua). Headless
   checks above stand in.

## Out of scope

- Functional changes beyond the prune list.
- README/HOTKEYS/CLAUDE.md doc updates beyond keybinding accuracy (freed `\`, removed git/md maps).
  These are updated as a final cleanup step, not a redesign.
- Reworking telescope vs snacks-picker overlap (kept intentionally; separate `<leader>s` / `<leader>p` prefixes).

## Rollback

`master` is untouched. If the migration is unsatisfactory: `git checkout master` and delete the
`vim-pack-migration` branch. lazy.nvim's `lazy-lock.json` is preserved on `master`.
