vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/greggh/claude-code.nvim' },
}

require('claude-code').setup()
