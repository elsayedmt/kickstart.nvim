-- Neogit: Git TUI, with diffview integration
vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/sindrets/diffview.nvim' },
  { src = 'https://github.com/NeogitOrg/neogit' },
}

local neogit = require 'neogit'
neogit.setup {}

vim.keymap.set('n', '<leader>gn', function()
  neogit.open {
    kind = 'split',
  }
end, { desc = 'Open Neogit UI' })
