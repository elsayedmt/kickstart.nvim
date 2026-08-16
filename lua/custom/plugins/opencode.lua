-- opencode.nvim: opencode integration (tmux provider)
vim.pack.add {
  { src = 'https://github.com/folke/snacks.nvim' },
  { src = 'https://github.com/NickvanDyke/opencode.nvim' },
}

local opencode_cmd = 'opencode --port'
---@type snacks.terminal.Opts
local snacks_terminal_opts = {
  win = {
    position = 'right',
    enter = false,
  },
}

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    start = function()
      require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
    end,
  },
}

vim.o.autoread = true

vim.keymap.set({ 'n', 'x' }, '<leader>oa', function() require('opencode').ask('@this: ') end, { desc = '[O]pencode [A]sk' })
vim.keymap.set({ 'n', 'x' }, '<leader>ox', function() require('opencode').select() end, { desc = '[O]pencode E[x]ecute action' })
vim.keymap.set({ 'n', 'x' }, '<leader>op', function() require('opencode').prompt '@this' end, { desc = '[O]pencode [P]rompt (add to chat)' })
vim.keymap.set('n', '<leader>ou', function() require('opencode').command 'session.half.page.up' end, { desc = '[O]pencode half page [U]p' })
vim.keymap.set('n', '<leader>od', function() require('opencode').command 'session.half.page.down' end, { desc = '[O]pencode half page [D]own' }) 
vim.keymap.set({ 'n', 't' }, '<leader>oo', function() require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts) end, { desc = '[O]pencode Toggle' })
vim.keymap.set({ 'n', 't' }, '<C-.>', function() require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts) end, { desc = 'Toggle OpenCode' })
