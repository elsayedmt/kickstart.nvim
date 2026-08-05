-- Load rustaceanvim on first Rust buffer (it provides :RustLsp used below)
if not vim.g.__rustaceanvim_loaded then
  vim.g.__rustaceanvim_loaded = true
  vim.pack.add { { src = 'https://github.com/mrcjkb/rustaceanvim' } }
  -- re-fire so rustaceanvim attaches to the current buffer
  vim.api.nvim_exec_autocmds('FileType', { buffer = vim.api.nvim_get_current_buf(), modeline = false })
end

local bufnr = vim.api.nvim_get_current_buf()

-- Rust-specific keybindings using rustaceanvim
local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc }) end

-- Run and Test
map('n', '<leader>rr', function() vim.cmd.RustLsp 'runnables' end, '[R]ust [R]unnables (run/debug)')

map('n', '<leader>rt', function() vim.cmd.RustLsp 'testables' end, '[R]ust [T]estables (run/debug tests)')

map('n', '<leader>rd', function() vim.cmd.RustLsp { 'runnables', bang = true } end, '[R]ust [D]ebug last runnable')

-- Code Exploration
map('n', '<leader>re', function() vim.cmd.RustLsp 'expandMacro' end, '[R]ust [E]xpand macro')

map('n', '<leader>rc', function() vim.cmd.RustLsp 'openCargo' end, '[R]ust open [C]argo.toml')

map('n', '<leader>rp', function() vim.cmd.RustLsp 'parentModule' end, '[R]ust [P]arent module')

-- Documentation and Diagnostics
map('n', '<leader>cd', function() vim.cmd.RustLsp 'openDocs' end, 'Open external [D]ocs (docs.rs)')

map('n', '<leader>rx', function() vim.cmd.RustLsp 'explainError' end, '[R]ust e[X]plain error')

map('n', '<leader>rh', function() vim.cmd.RustLsp 'hover' 'actions' end, '[R]ust [H]over actions')

-- Advanced Views
map('n', '<leader>rg', function() vim.cmd.RustLsp 'crateGraph' end, '[R]ust crate [G]raph')

map('n', '<leader>rs', function() vim.cmd.RustLsp 'syntaxTree' end, '[R]ust [S]yntax tree')

-- Code Manipulation
map('n', '<leader>rj', function() vim.cmd.RustLsp 'joinLines' end, '[R]ust [J]oin lines')

map('n', '<leader>rmu', function() vim.cmd.RustLsp { 'moveItem', 'up' } end, '[R]ust [M]ove item [U]p')

map('n', '<leader>rmd', function() vim.cmd.RustLsp { 'moveItem', 'down' } end, '[R]ust [M]ove item [D]own')

-- Rebuild proc macros
-- <leader>rM, not <leader>rm: the latter is a prefix of <leader>rmu/<leader>rmd
-- above, so it would stall for 'timeoutlen' (300ms) on every press.
map('n', '<leader>rM', function() vim.cmd.RustLsp 'rebuildProcMacros' end, '[R]ust rebuild proc [M]acros')
