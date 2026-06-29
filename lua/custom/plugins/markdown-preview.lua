-- Browser-based markdown preview with mermaid diagram support.
-- Plugin ships frontend assets that must be built once; vim.pack has no build
-- hook, so we build via the `User PackChanged` event it fires after install/update.

-- Config globals must be set BEFORE the plugin loads.
vim.g.mkdp_auto_close = 0 -- keep the browser tab open when leaving the markdown buffer

vim.pack.add { { src = 'https://github.com/iamcco/markdown-preview.nvim' } }

-- Build the frontend assets when this plugin is installed or updated.
vim.api.nvim_create_autocmd('User', {
  pattern = 'PackChanged',
  callback = function(ev)
    local d = ev.data
    if
      d
      and d.spec
      and d.spec.name == 'markdown-preview.nvim'
      and (d.kind == 'install' or d.kind == 'update')
    then
      vim.fn['mkdp#util#install']()
    end
  end,
})

-- Buffer-local toggle keymap for markdown files.
-- NOTE: <leader>m is Harpoon's "Mark" group; we use <leader>mv ("markdown view")
-- to avoid clobbering its global maps (e.g. <leader>mp = Harpoon previous file).
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'markdown.mdx' },
  callback = function(ev)
    vim.keymap.set('n', '<leader>mv', '<cmd>MarkdownPreviewToggle<cr>', {
      buffer = ev.buf,
      desc = 'Markdown Preview (toggle)',
    })
  end,
})
