-- Aerial: document symbol tree, docked on the right by edgy
vim.pack.add {
  { src = 'https://github.com/stevearc/aerial.nvim' },
}

require('aerial').setup {
  backends = { 'lsp', 'treesitter', 'markdown', 'man' },
  layout = {
    default_direction = 'right',
    placement = 'edge',
    resize_to_content = false,
  },
  attach_mode = 'global',
  close_automatic_events = {},
  show_guides = true,
  filter_kind = false,
}

vim.keymap.set('n', '<leader>cs', '<cmd>AerialToggle<cr>', { desc = '[C]ode [S]ymbols Outline' })
vim.keymap.set('n', '<leader>cS', '<cmd>AerialNavToggle<cr>', { desc = '[C]ode [S]ymbols Nav' })
