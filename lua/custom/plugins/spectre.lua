-- nvim-spectre: Search and replace across project
-- WARNING: Always commit your files before replacing text (no undo support)

return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = 'Spectre', -- Lazy load on command
  keys = {
    {
      '<leader>SS',
      function()
        require('spectre').toggle()
      end,
      desc = 'Toggle [S]pectre (search/replace)',
    },
    {
      '<leader>Sw',
      function()
        require('spectre').open_visual { select_word = true }
      end,
      desc = '[S]pectre: Replace current [W]ord',
    },
    {
      '<leader>Sr',
      function()
        require('spectre').open_visual()
      end,
      mode = 'v',
      desc = '[S]pectre: [R]eplace selection',
    },
    {
      '<leader>Sf',
      function()
        require('spectre').open_file_search { select_word = true }
      end,
      desc = '[S]pectre: Replace in current [F]ile',
    },
  },
  opts = {
    color_devicons = true,
    open_cmd = 'vnew',
    live_update = false, -- auto execute search when you write files
    line_sep_start = '┌-----------------------------------------',
    result_padding = '¦  ',
    line_sep = '└-----------------------------------------',
    highlight = {
      ui = 'String',
      search = 'DiffChange',
      replace = 'DiffDelete',
    },
    -- Use ripgrep for search (make sure it's installed: brew install ripgrep)
    -- Use sed for replace (macOS users: brew install gnu-sed)
    default = {
      find = {
        cmd = 'rg',
        options = { 'ignore-case' },
      },
      replace = {
        cmd = 'sed',
      },
    },
  },
}
