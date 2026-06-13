-- refactoring.nvim: extract/inline/debug refactorings
vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/lewis6991/async.nvim' },
  { src = 'https://github.com/ThePrimeagen/refactoring.nvim' },
}

require('refactoring').setup {
  prompt_func_return_type = { go = false, java = false, cpp = false, c = false, h = false, hpp = false, cxx = false },
  prompt_func_param_type = { go = false, java = false, cpp = false, c = false, h = false, hpp = false, cxx = false },
  printf_statements = {},
  print_var_statements = {},
  show_success_message = true,
}

pcall(function()
  require('telescope').load_extension 'refactoring'
end)

-- Extract (visual)
vim.keymap.set('x', '<leader>xe', function() require('refactoring').refactor 'Extract Function' end, { desc = 'R[x]factor: [E]xtract Function' })
vim.keymap.set('x', '<leader>xf', function() require('refactoring').refactor 'Extract Function To File' end, { desc = 'R[x]factor: Extract to [F]ile' })
vim.keymap.set('x', '<leader>xv', function() require('refactoring').refactor 'Extract Variable' end, { desc = 'R[x]factor: Extract [V]ariable' })
vim.keymap.set('x', '<leader>xb', function() require('refactoring').refactor 'Extract Block' end, { desc = 'R[x]factor: Extract [B]lock' })
vim.keymap.set('x', '<leader>xF', function() require('refactoring').refactor 'Extract Block To File' end, { desc = 'R[x]factor: Extract Block to [F]ile' })

-- Inline
vim.keymap.set({ 'n', 'x' }, '<leader>xi', function() require('refactoring').refactor 'Inline Variable' end, { desc = 'R[x]factor: [I]nline Variable' })
vim.keymap.set('n', '<leader>xI', function() require('refactoring').refactor 'Inline Function' end, { desc = 'R[x]factor: [I]nline Function' })

-- Debug helpers
vim.keymap.set({ 'n', 'x' }, '<leader>xp', function() require('refactoring').debug.printf { below = false } end, { desc = 'R[x]factor: Debug [P]rint' })
vim.keymap.set('n', '<leader>xV', function() require('refactoring').debug.print_var() end, { desc = 'R[x]factor: Debug Print [V]ariable' })
vim.keymap.set('n', '<leader>xc', function() require('refactoring').debug.cleanup {} end, { desc = 'R[x]factor: Debug [C]leanup' })

-- Menu
vim.keymap.set({ 'n', 'x' }, '<leader>xx', function() require('refactoring').select_refactor() end, { desc = 'R[x]factor: Select operation' })
