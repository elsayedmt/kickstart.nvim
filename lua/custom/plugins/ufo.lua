-- nvim-ufo: Modern folding with high performance
-- Provides enhanced code folding with LSP, Treesitter, and indent providers
return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  event = 'BufReadPost',
  opts = {
    -- Use LSP as the primary provider, fallback to indent
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end,
  },
  config = function(_, opts)
    -- Set recommended vim options for folding
    vim.o.foldcolumn = '1' -- Show fold column
    vim.o.foldlevel = 99 -- High default: don't fold on open
    vim.o.foldlevelstart = 99 -- Start with all folds open
    vim.o.foldenable = true -- Enable folding

    -- Setup nvim-ufo with options
    require('ufo').setup(opts)

    -- Keymaps for folding
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', 'zK', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek fold or show hover' })
  end,
}
