-- opencode.nvim: opencode integration (tmux provider)
vim.pack.add {
  { src = 'https://github.com/folke/snacks.nvim' },
  { src = 'https://github.com/NickvanDyke/opencode.nvim' },
}

vim.g.opencode_opts = {
  provider = {
    enabled = 'tmux',
    tmux = { options = '-h' },
  },
}

vim.o.autoread = true

vim.keymap.set({ 'n', 'x' }, '<leader>oa', function() require('opencode').ask('@this: ', { submit = true }) end, { desc = '[O]pencode [A]sk' })
vim.keymap.set({ 'n', 'x' }, '<leader>ox', function() require('opencode').select() end, { desc = '[O]pencode E[x]ecute action' })
vim.keymap.set({ 'n', 'x' }, '<leader>op', function() require('opencode').prompt '@this' end, { desc = '[O]pencode [P]rompt (add to chat)' })
vim.keymap.set({ 'n', 't' }, '<leader>oo', function() require('opencode').toggle() end, { desc = '[O]pencode Toggle' })
vim.keymap.set({ 'n', 't' }, '<C-.>', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
vim.keymap.set('n', '<leader>ou', function() require('opencode').command 'session.half.page.up' end, { desc = '[O]pencode half page [U]p' })
vim.keymap.set('n', '<leader>od', function() require('opencode').command 'session.half.page.down' end, { desc = '[O]pencode half page [D]own' })
