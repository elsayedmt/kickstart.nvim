-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
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
  },
}
