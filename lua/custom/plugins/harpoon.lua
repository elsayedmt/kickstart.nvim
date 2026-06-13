-- Harpoon 2: Quick file navigation and marking
-- Mark your most frequently used files and jump between them instantly

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>ma',
      function()
        require('harpoon'):list():add()
      end,
      desc = '[M]ark: [A]dd file to Harpoon',
    },
    {
      '<leader>mm',
      function()
        local harpoon = require 'harpoon'
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = '[M]ark: Toggle Harpoon [M]enu',
    },
    {
      '<leader>1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = '[M]ark: Jump to file 1',
    },
    {
      '<leader>2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = '[M]ark: Jump to file 2',
    },
    {
      '<leader>3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = '[M]ark: Jump to file 3',
    },
    {
      '<leader>4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = '[M]ark: Jump to file 4',
    },
    -- Navigate between marked files
    {
      '<leader>mp',
      function()
        require('harpoon'):list():prev()
      end,
      desc = '[M]ark: [P]revious file',
    },
    {
      '<leader>mn',
      function()
        require('harpoon'):list():next()
      end,
      desc = '[M]ark: [N]ext file',
    },
    -- Clear all marks
    {
      '<leader>mc',
      function()
        require('harpoon'):list():clear()
      end,
      desc = '[M]ark: [C]lear all marks',
    },
  },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    }
  end,
}
