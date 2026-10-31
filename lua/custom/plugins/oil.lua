-- oil.nvim: edit the filesystem like a buffer
vim.pack.add { { src = 'https://github.com/stevearc/oil.nvim' } }
require('oil').setup {
  -- Free <C-h>/<C-l> for window navigation; split-open moves to <C-x>, refresh to gR.
  keymaps = {
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['<C-x>'] = { 'actions.select', opts = { horizontal = true } },
    ['gR'] = 'actions.refresh',
  },
}

vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory (Oil)' })
