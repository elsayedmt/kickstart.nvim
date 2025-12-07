return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  },
  keys = {
    -- Explorer & Utilities (Snacks-specific features)
    {
      '<leader>e',
      function()
        Snacks.explorer()
      end,
      desc = 'File Explorer',
    },
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    
    -- Snacks Pickers (using <leader>p prefix to avoid Telescope conflicts)
    -- Top-level quick access
    {
      '<leader>p<space>',
      function()
        Snacks.picker.smart()
      end,
      desc = '[P]icker Smart Find',
    },
    {
      '<leader>p,',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[P]icker Buffers',
    },
    {
      '<leader>p/',
      function()
        Snacks.picker.grep()
      end,
      desc = '[P]icker Grep',
    },
    {
      '<leader>p:',
      function()
        Snacks.picker.command_history()
      end,
      desc = '[P]icker Command History',
    },
    
    -- Find
    {
      '<leader>pfb',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[P]icker [F]ind [B]uffers',
    },
    {
      '<leader>pfc',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[P]icker [F]ind [C]onfig File',
    },
    {
      '<leader>pff',
      function()
        Snacks.picker.files()
      end,
      desc = '[P]icker [F]ind [F]iles',
    },
    {
      '<leader>pfg',
      function()
        Snacks.picker.git_files()
      end,
      desc = '[P]icker [F]ind [G]it Files',
    },
    {
      '<leader>pfp',
      function()
        Snacks.picker.projects()
      end,
      desc = '[P]icker [F]ind [P]rojects',
    },
    {
      '<leader>pfr',
      function()
        Snacks.picker.recent()
      end,
      desc = '[P]icker [F]ind [R]ecent',
    },
    
    -- Git (using <leader>pg prefix for Snacks git pickers)
    {
      '<leader>pgb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = '[P]icker [G]it [B]ranches',
    },
    {
      '<leader>pgl',
      function()
        Snacks.picker.git_log()
      end,
      desc = '[P]icker [G]it [L]og',
    },
    {
      '<leader>pgL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = '[P]icker [G]it Log [L]ine',
    },
    {
      '<leader>pgs',
      function()
        Snacks.picker.git_status()
      end,
      desc = '[P]icker [G]it [S]tatus',
    },
    {
      '<leader>pgS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = '[P]icker [G]it [S]tash',
    },
    {
      '<leader>pgd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = '[P]icker [G]it [D]iff (Hunks)',
    },
    {
      '<leader>pgf',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = '[P]icker [G]it Log [F]ile',
    },
    
    -- Git operations (non-picker git features)
    {
      '<leader>gb',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
      mode = { 'n', 'v' },
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    
    -- Picker Search (using <leader>ps prefix)
    {
      '<leader>ps"',
      function()
        Snacks.picker.registers()
      end,
      desc = '[P]icker [S]earch Registers',
    },
    {
      '<leader>ps/',
      function()
        Snacks.picker.search_history()
      end,
      desc = '[P]icker [S]earch History',
    },
    {
      '<leader>psa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = '[P]icker [S]earch Autocmds',
    },
    {
      '<leader>psb',
      function()
        Snacks.picker.lines()
      end,
      desc = '[P]icker [S]earch [B]uffer Lines',
    },
    {
      '<leader>psB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = '[P]icker [S]earch Grep Open [B]uffers',
    },
    {
      '<leader>psg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[P]icker [S]earch [G]rep',
    },
    {
      '<leader>psw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[P]icker [S]earch [W]ord',
      mode = { 'n', 'x' },
    },
    {
      '<leader>psc',
      function()
        Snacks.picker.command_history()
      end,
      desc = '[P]icker [S]earch [C]ommand History',
    },
    {
      '<leader>psC',
      function()
        Snacks.picker.commands()
      end,
      desc = '[P]icker [S]earch [C]ommands',
    },
    {
      '<leader>psd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[P]icker [S]earch [D]iagnostics',
    },
    {
      '<leader>psD',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = '[P]icker [S]earch Buffer [D]iagnostics',
    },
    {
      '<leader>psh',
      function()
        Snacks.picker.help()
      end,
      desc = '[P]icker [S]earch [H]elp Pages',
    },
    {
      '<leader>psH',
      function()
        Snacks.picker.highlights()
      end,
      desc = '[P]icker [S]earch [H]ighlights',
    },
    {
      '<leader>psi',
      function()
        Snacks.picker.icons()
      end,
      desc = '[P]icker [S]earch [I]cons',
    },
    {
      '<leader>psj',
      function()
        Snacks.picker.jumps()
      end,
      desc = '[P]icker [S]earch [J]umps',
    },
    {
      '<leader>psk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[P]icker [S]earch [K]eymaps',
    },
    {
      '<leader>psl',
      function()
        Snacks.picker.loclist()
      end,
      desc = '[P]icker [S]earch [L]ocation List',
    },
    {
      '<leader>psm',
      function()
        Snacks.picker.marks()
      end,
      desc = '[P]icker [S]earch [M]arks',
    },
    {
      '<leader>psM',
      function()
        Snacks.picker.man()
      end,
      desc = '[P]icker [S]earch [M]an Pages',
    },
    {
      '<leader>psp',
      function()
        Snacks.picker.lazy()
      end,
      desc = '[P]icker [S]earch [P]lugin Spec',
    },
    {
      '<leader>psq',
      function()
        Snacks.picker.qflist()
      end,
      desc = '[P]icker [S]earch [Q]uickfix List',
    },
    {
      '<leader>psR',
      function()
        Snacks.picker.resume()
      end,
      desc = '[P]icker [S]earch [R]esume',
    },
    {
      '<leader>psu',
      function()
        Snacks.picker.undo()
      end,
      desc = '[P]icker [S]earch [U]ndo History',
    },
    {
      '<leader>psc',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = '[P]icker [S]earch [C]olorschemes',
    },
    
    -- LSP (using <leader>pl prefix for Snacks LSP pickers)
    {
      '<leader>pld',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = '[P]icker [L]SP [D]efinitions',
    },
    {
      '<leader>plD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = '[P]icker [L]SP [D]eclarations',
    },
    {
      '<leader>plr',
      function()
        Snacks.picker.lsp_references()
      end,
      desc = '[P]icker [L]SP [R]eferences',
    },
    {
      '<leader>pli',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = '[P]icker [L]SP [I]mplementations',
    },
    {
      '<leader>plt',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = '[P]icker [L]SP [T]ype Definitions',
    },
    {
      '<leader>pls',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = '[P]icker [L]SP [S]ymbols',
    },
    {
      '<leader>plS',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = '[P]icker [L]SP Workspace [S]ymbols',
    },
    -- Buffer operations
    {
      '<leader>bx',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer (close)',
    },
    
    -- Code operations
    {
      '<leader>cR',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'Rename File',
    },
    
    -- UI & Utility
    {
      '<leader>z',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle Zen Mode',
    },
    {
      '<leader>Z',
      function()
        Snacks.zen.zoom()
      end,
      desc = 'Toggle Zoom',
    },
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<leader>N',
      desc = 'Neovim News',
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        }
      end,
    },
    
    -- Terminal
    {
      '<c-/>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<c-_>',
      function()
        Snacks.terminal()
      end,
      desc = 'which_key_ignore',
    },
    
    -- Word navigation
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        Snacks.toggle.indent():map '<leader>ug'
        Snacks.toggle.dim():map '<leader>uD'
      end,
    })
  end,
}
