return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        enabled = 'tmux',
        tmux = {
          options = '-h', -- Open in a horizontal split (or use '-v' for vertical)
        },
      },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- OpenCode keymaps (using <leader>o prefix to avoid conflicts with Vim defaults)
    vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = '[O]pencode [A]sk' })
    vim.keymap.set({ 'n', 'x' }, '<leader>ox', function()
      require('opencode').select()
    end, { desc = '[O]pencode E[x]ecute action' })
    vim.keymap.set({ 'n', 'x' }, '<leader>op', function()
      require('opencode').prompt '@this'
    end, { desc = '[O]pencode [P]rompt (add to chat)' })
    vim.keymap.set({ 'n', 't' }, '<leader>oo', function()
      require('opencode').toggle()
    end, { desc = '[O]pencode Toggle' })
    -- Also keep <C-.> as it's convenient and doesn't conflict
    vim.keymap.set({ 'n', 't' }, '<C-.>', function()
      require('opencode').toggle()
    end, { desc = 'Toggle opencode' })
    
    -- OpenCode navigation (optional - you can use regular scrolling in the opencode window)
    vim.keymap.set('n', '<leader>ou', function()
      require('opencode').command 'session.half.page.up'
    end, { desc = '[O]pencode half page [U]p' })
    vim.keymap.set('n', '<leader>od', function()
      require('opencode').command 'session.half.page.down'
    end, { desc = '[O]pencode half page [D]own' })
    
    -- No need to remap + and - since we're not overriding <C-a> and <C-x> anymore
    -- Standard Vim increment/decrement (<C-a>/<C-x>) remain untouched
  end,
}
