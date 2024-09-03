local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', '<leader>cd', function()
  vim.cmd.RustLsp 'openDocs' -- supports rust-analyzer's grouping
  -- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr })
