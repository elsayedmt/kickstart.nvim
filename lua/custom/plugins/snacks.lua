-- Snacks.nvim: dashboard, explorer, pickers, notifier, terminal, toggles, etc.
vim.pack.add { { src = 'https://github.com/folke/snacks.nvim' } }

require('snacks').setup {
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    -- Default preset includes a `startup` section that hard-requires `lazy.stats`,
    -- which errors on UIEnter now that we're on vim.pack. Replace it with a
    -- lazy-free plugin-count line (pcall-guarded so the dashboard can't crash).
    --
    -- Counts package directories on disk rather than calling vim.pack.get():
    -- that shells out to git once per plugin and takes ~2.3s for 43 plugins,
    -- with no caching. It runs in the dashboard render path, so it blocked
    -- UIEnter on every single startup. Reading the directory is ~0.15ms and
    -- yields the same number.
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
      function()
        local ok, n = pcall(function()
          local count = 0
          for _, base in ipairs(vim.fn.globpath(vim.fn.stdpath 'data', 'site/pack/*/opt', false, true)) do
            for _, ty in vim.fs.dir(base) do
              if ty == 'directory' or ty == 'link' then count = count + 1 end
            end
          end
          return count
        end)
        n = ok and n or 0
        return {
          align = 'center',
          padding = 1,
          text = {
            { '⚡ ', hl = 'special' },
            { n .. ' plugins', hl = 'footer' },
          },
        }
      end,
    },
  },
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
