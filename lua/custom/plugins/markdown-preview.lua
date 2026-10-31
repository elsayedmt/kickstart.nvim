-- Browser-based markdown preview with mermaid diagram support.
-- Plugin ships frontend assets that must be built once; vim.pack has no build
-- hook, so we build via the `PackChanged` event it fires after install/update.

-- Config globals must be set BEFORE the plugin loads.
vim.g.mkdp_auto_close = 0 -- keep the browser tab open when leaving the markdown buffer

-- Build the frontend assets when this plugin is installed or updated. Registered
-- before vim.pack.add so the event from a fresh install is not missed.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local d = ev.data
    if d.spec.name ~= 'markdown-preview.nvim' or (d.kind ~= 'install' and d.kind ~= 'update') then return end
    if not d.active then vim.cmd.packadd 'markdown-preview.nvim' end
    vim.fn['mkdp#util#install']()
  end,
})

vim.pack.add { { src = 'https://github.com/iamcco/markdown-preview.nvim' } }

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
