-- nvim-ufo: high-performance folding (deferred to first buffer read)
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.api.nvim_create_autocmd('BufReadPost', {
  once = true,
  callback = function()
    vim.pack.add {
      { src = 'https://github.com/kevinhwang91/promise-async' },
      { src = 'https://github.com/kevinhwang91/nvim-ufo' },
    }
    require('ufo').setup {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    }
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
    vim.keymap.set('n', 'zK', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek fold or show hover' })
  end,
})
