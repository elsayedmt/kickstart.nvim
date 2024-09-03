vim.cmd [[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]]
vim.cmd [[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]]
vim.cmd [[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]]
vim.cmd [[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]]
vim.cmd [[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]]

-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)

-- See the kickstart.nvim README for more information
return {
  --  {
  --    'saecki/crates.nvim',
  --    tag = 'stable',
  --    config = function()
  --      require('crates').setup()
  --    end,
  --  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = 'rust',
    dependencies = 'neovim/nvim-lspconfig',
  },
}
