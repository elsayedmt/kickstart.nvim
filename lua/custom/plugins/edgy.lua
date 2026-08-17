vim.pack.add {
  { src = 'https://github.com/folke/edgy.nvim' },
}

require('edgy').setup {
  animate = { fps = 120, cps = 400 },
  bottom = {
    {
      ft = 'snacks_terminal',
      size = { height = 0.4 },
      title = '%{b:snacks_terminal.id}: %{b:term_title}',
      filter = function(_, win) return vim.w[win].snacks_win and vim.w[win].snacks_win.position == 'bottom' end,
    },
    { ft = 'qf', title = 'QuickFix' },
    {
      ft = 'help',
      size = { height = 20 },
      filter = function(buf) return vim.bo[buf].buftype == 'help' end,
    },
    { ft = 'spectre_panel', size = { height = 0.4 } },
  },
  left = {
    {
      ft = 'snacks_layout_box',
      title = 'Explorer',
      size = { width = 0.2 },
      filter = function(_, win) return vim.w[win].snacks_win and vim.w[win].snacks_win.position == 'left' end,
    },
    {
      ft = 'NeogitStatus',
      title = 'Git Changes',
      size = { height = 0.4 },
      pinned = true,
      collapsed = true,
      open = function() require('neogit').open { kind = 'vsplit' } end,
    },
  },
  right = {
    {
      ft = 'aerial',
      title = 'Symbols',
      size = { width = 0.2 },
      open = 'AerialOpen',
    },
    {
      ft = 'snacks_terminal',
      title = 'OpenCode',
      size = { width = 0.35 },
      filter = function(_, win) return vim.w[win].snacks_win and vim.w[win].snacks_win.position == 'right' end,
    },
  },
}

--- Expand an edgebar section by filetype, focusing it if already open.
local function expand_view(ft)
  for _, edgebar in pairs(require('edgy.config').layout) do
    for _, view in ipairs(edgebar.views) do
      if view.ft == ft then
        if view.wins[1] then
          view.wins[1]:focus()
        else
          view:open_pinned()
        end
        return
      end
    end
  end
end

vim.keymap.set('n', '<leader>gs', function() expand_view 'NeogitStatus' end, { desc = '[G]it [S]tatus Panel' })

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- prevents main splits from jumping when an edgebar opens
vim.opt.splitkeep = 'screen'
