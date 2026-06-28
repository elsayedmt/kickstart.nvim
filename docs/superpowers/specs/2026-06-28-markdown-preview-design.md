# Markdown Preview with Mermaid — Design

**Date:** 2026-06-28
**Status:** Approved (pending spec review)

## Goal

Add a markdown preview capability to the Neovim config that renders markdown
in a browser tab, including **mermaid diagrams**, math, and flowcharts.

## Decision

Use **markdown-preview.nvim** (`iamcco/markdown-preview.nvim`).

### Why

- Browser-based rendering → mermaid diagrams render natively (real JS in a real browser).
- Node-only runtime, already installed (`node v25`, `npx` present). No new system deps.
- Mature, mermaid + KaTeX support built in, scroll-syncs with the cursor.

### Alternatives considered

- **peek.nvim** — also browser-based with mermaid, but requires Deno (not installed). Rejected to avoid a new system dependency.
- **render-markdown.nvim / markview.nvim** — in-editor decoration. Mermaid can't render without a terminal image protocol + extra setup. Rejected: mermaid is the core requirement.

## The build-step problem

markdown-preview.nvim ships frontend assets that must be built once after install.
`lazy.nvim` handled this with a `build =` key, but this config has migrated to
**`vim.pack`, which has no build hook**.

**Solution:** Listen for the `User PackChanged` autocommand that `vim.pack` fires
after install/update, and run the plugin's build function when *this* plugin changes.

## Implementation

**File:** `lua/custom/plugins/markdown-preview.lua`
(auto-loaded by the existing directory loader in `lua/custom/plugins/init.lua`)

Contents, in order:

1. **Config vars set before load** (plugin reads these at startup):
   - `vim.g.mkdp_auto_close = 0` — tab stays open when leaving the markdown buffer.
   - Any other sensible defaults left at plugin default.

2. **`vim.pack.add`** the repo:
   ```lua
   vim.pack.add { { src = 'https://github.com/iamcco/markdown-preview.nvim' } }
   ```

3. **Auto-build via PackChanged:**
   ```lua
   vim.api.nvim_create_autocmd('User', {
     pattern = 'PackChanged',
     callback = function(ev)
       local d = ev.data
       if d and d.spec and d.spec.name == 'markdown-preview.nvim'
          and (d.kind == 'install' or d.kind == 'update') then
         vim.fn['mkdp#util#install']()
       end
     end,
   })
   ```
   `mkdp#util#install()` downloads/builds the prebuilt frontend — no yarn needed.

4. **Keymap** (buffer-local to markdown filetypes via a FileType autocmd, so it
   doesn't pollute other buffers):
   - `<leader>mp` → `:MarkdownPreviewToggle` — "Markdown Preview (toggle)".
   - Register the `<leader>m` group label with which-key if available.

## First-time setup note

On the very first install, `mkdp#util#install()` runs automatically via the
PackChanged hook. If for any reason assets are missing, the manual fallback is
`:call mkdp#util#install()`.

## Verification

1. Open a `.md` file containing a ` ```mermaid ` code block.
2. Press `<leader>mp`.
3. Confirm a browser tab opens and the mermaid diagram renders as a diagram (not raw text).
4. Edit the file; confirm the preview updates live.
5. Switch to another buffer; confirm the tab stays open (auto_close = 0).

## Out of scope (YAGNI)

- In-editor decoration (render-markdown.nvim) — separate concern, not requested.
- Custom CSS theming — can be added later via `vim.g.mkdp_*` vars if wanted.
