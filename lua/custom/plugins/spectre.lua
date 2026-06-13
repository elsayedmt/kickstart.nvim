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
