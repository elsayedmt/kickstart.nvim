-- refactoring.nvim: Advanced refactoring operations
-- Based on Martin Fowler's refactoring patterns
-- Supports: TypeScript, JavaScript, Lua, C/C++, Go, Python, Java, PHP, Ruby, C#, and Rust

return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  opts = {
    prompt_func_return_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    prompt_func_param_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    printf_statements = {},
    print_var_statements = {},
    show_success_message = true, -- Shows a message with information about the refactor on success
  },
  keys = {
    -- Extract refactorings (visual mode)
    {
      '<leader>xe',
      function()
        require('refactoring').refactor 'Extract Function'
      end,
      mode = 'x',
      desc = 'R[x]factor: [E]xtract Function',
    },
    {
      '<leader>xf',
      function()
        require('refactoring').refactor 'Extract Function To File'
      end,
      mode = 'x',
      desc = 'R[x]factor: Extract to [F]ile',
    },
    {
      '<leader>xv',
      function()
        require('refactoring').refactor 'Extract Variable'
      end,
      mode = 'x',
      desc = 'R[x]factor: Extract [V]ariable',
    },
    {
      '<leader>xb',
      function()
        require('refactoring').refactor 'Extract Block'
      end,
      mode = 'x',
      desc = 'R[x]factor: Extract [B]lock',
    },
    {
      '<leader>xF',
      function()
        require('refactoring').refactor 'Extract Block To File'
      end,
      mode = 'x',
      desc = 'R[x]factor: Extract Block to [F]ile',
    },

    -- Inline refactorings (normal and visual mode)
    {
      '<leader>xi',
      function()
        require('refactoring').refactor 'Inline Variable'
      end,
      mode = { 'n', 'x' },
      desc = 'R[x]factor: [I]nline Variable',
    },
    {
      '<leader>xI',
      function()
        require('refactoring').refactor 'Inline Function'
      end,
      mode = 'n',
      desc = 'R[x]factor: [I]nline Function',
    },

    -- Debug helpers
    {
      '<leader>xp',
      function()
        require('refactoring').debug.printf { below = false }
      end,
      mode = { 'n', 'x' },
      desc = 'R[x]factor: Debug [P]rint',
    },
    {
      '<leader>xv',
      function()
        require('refactoring').debug.print_var()
      end,
      mode = 'n',
      desc = 'R[x]factor: Debug Print [V]ariable',
    },
    {
      '<leader>xc',
      function()
        require('refactoring').debug.cleanup {}
      end,
      mode = 'n',
      desc = 'R[x]factor: Debug [C]leanup',
    },

    -- Refactor menu (using telescope if available, otherwise vim.ui.select)
    {
      '<leader>xx',
      function()
        require('refactoring').select_refactor()
      end,
      mode = { 'n', 'x' },
      desc = 'R[x]factor: Select operation',
    },
  },
  config = function(_, opts)
    require('refactoring').setup(opts)

    -- Optional: Load refactoring Telescope extension if Telescope is available
    if pcall(require, 'telescope') then
      require('telescope').load_extension 'refactoring'
    end
  end,
}
