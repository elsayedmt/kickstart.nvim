-- typescript-tools.nvim (deferred to first JS/TS filetype)
local group = vim.api.nvim_create_augroup('typescript_tools_lazy', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' },
  callback = function(ev)
    vim.api.nvim_del_augroup_by_id(group)
    vim.pack.add {
      { src = 'https://github.com/nvim-lua/plenary.nvim' },
      { src = 'https://github.com/pmizio/typescript-tools.nvim' },
    }
    require('typescript-tools').setup {
      settings = {
        tsserver_format_options = { tabSize = 2, indentSize = 2 },
      },
    }
    -- re-fire so the just-loaded plugin attaches to the current buffer
    vim.api.nvim_exec_autocmds('FileType', { buffer = ev.buf, modeline = false })
  end,
})
