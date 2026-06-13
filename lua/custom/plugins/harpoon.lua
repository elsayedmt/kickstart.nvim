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
