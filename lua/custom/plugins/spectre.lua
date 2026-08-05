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

-- Mapped under <leader>r ([R]eplace) rather than <leader>S: <leader>S is the
-- Snacks scratch-buffer picker, and any <leader>S* map here would stall that
-- bare <leader>S for 'timeoutlen' (300ms) on every press.
vim.keymap.set('n', '<leader>rr', function()
  ensure()
  require('spectre').toggle()
end, { desc = 'Toggle Spect[r]e (search/[r]eplace)' })

vim.keymap.set('n', '<leader>rw', function()
  ensure()
  require('spectre').open_visual { select_word = true }
end, { desc = '[R]eplace current [W]ord' })

vim.keymap.set('v', '<leader>rr', function()
  ensure()
  require('spectre').open_visual()
end, { desc = '[R]eplace selection' })

vim.keymap.set('n', '<leader>rf', function()
  ensure()
  require('spectre').open_file_search { select_word = true }
end, { desc = '[R]eplace in current [F]ile' })
