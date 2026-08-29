-- overseer.nvim: task runner. Two things live here:
--   * the builtin template providers (npm/cargo/make/just/...), reached via <leader>xr
--   * a "run file" template registered below, which is the single-keystroke path
--     for "execute the buffer I am looking at" (<leader>xx)
-- Keymaps sit under <leader>x ("e[X]ecute") because <leader>o is opencode's and
-- <leader>r is claimed buffer-locally by after/ftplugin/rust.lua.

vim.pack.add { { src = 'https://github.com/stevearc/overseer.nvim' } }

local overseer = require 'overseer'

overseer.setup {
  -- Patches nvim-dap so launch.json preLaunchTask/postDebugTask work; kickstart's
  -- debug.lua already installs dap, so this costs nothing.
  dap = true,
  task_list = {
    direction = 'bottom',
    min_height = 12,
  },
  form = { border = 'rounded' },
  task_win = { border = 'rounded' },
}

-- How to execute a single file, by filetype. `nil` means "the file is executable
-- on its own" (shebang), which is overseer's default when cmd is just the path.
local file_runners = {
  typescript = { 'bun' },
  typescriptreact = { 'bun' },
  javascript = { 'bun' },
  javascriptreact = { 'bun' },
  python = { 'python3' },
  go = { 'go', 'run' },
  sh = { 'bash' },
  bash = { 'bash' },
  zsh = { 'zsh' },
  ruby = { 'ruby' },
  php = { 'php' },
}

overseer.register_template {
  name = 'run file',
  builder = function()
    local file = vim.fn.expand '%:p'
    local prefix = file_runners[vim.bo.filetype]
    local cmd = prefix and vim.list_extend(vim.deepcopy(prefix), { file }) or { file }
    return {
      cmd = cmd,
      -- Run from the file's own directory so relative paths inside the script resolve.
      cwd = vim.fn.expand '%:p:h',
      components = {
        { 'on_output_quickfix', set_diagnostics = true },
        'on_result_diagnostics',
        'default',
      },
    }
  end,
  -- This version of overseer only supports `filetype` and `dir` conditions
  -- (no callback), so the buffer-is-a-real-file check lives in run_file below.
  condition = { filetype = vim.tbl_keys(file_runners) },
}

-- The template is only offered for known filetypes, but nothing stops it firing
-- in a scratch or unnamed buffer of that filetype, where `%:p` is meaningless.
local function is_real_file()
  if vim.bo.buftype ~= '' or vim.fn.expand '%' == '' then
    vim.notify('Not a file buffer -- nothing to run', vim.log.levels.WARN)
    return false
  end
  return true
end

-- Rust is deliberately absent from file_runners: a .rs file is almost never
-- runnable alone, so <leader>xx defers to the cargo template provider instead.
local function run_file()
  if not is_real_file() then return end
  if vim.bo.filetype == 'rust' then return overseer.run_task { name = 'cargo run' } end
  if vim.bo.filetype == 'lua' then
    -- Sourcing in-process is the only way a lua file can affect this nvim.
    vim.cmd 'write'
    vim.cmd 'source %'
    return vim.notify('sourced ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
  end
  vim.cmd 'write'
  overseer.run_task({ name = 'run file' }, function(task)
    if not task then vim.notify('No "run file" runner for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN) end
  end)
end

-- Same as run_file, but re-runs on every write of that file.
local function watch_file()
  if not is_real_file() then return end
  vim.cmd 'write'
  local path = vim.fn.expand '%:p'
  overseer.run_task({ name = 'run file', autostart = false }, function(task)
    if not task then return vim.notify('No "run file" runner for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN) end
    task:add_component { 'restart_on_save', paths = { path } }
    task:start()
    task:open_output 'vertical'
  end)
end

vim.keymap.set('n', '<leader>xx', run_file, { desc = 'Run current file' })
vim.keymap.set('n', '<leader>xw', watch_file, { desc = 'Watch + rerun current file on save' })
vim.keymap.set('n', '<leader>xr', '<cmd>OverseerRun<cr>', { desc = 'Run task (pick template)' })
vim.keymap.set('n', '<leader>xt', '<cmd>OverseerToggle<cr>', { desc = 'Toggle task list' })
vim.keymap.set('n', '<leader>xo', '<cmd>OverseerOpen<cr>', { desc = 'Open task list' })
vim.keymap.set('n', '<leader>xa', '<cmd>OverseerTaskAction<cr>', { desc = 'Task action' })
vim.keymap.set('n', '<leader>xs', '<cmd>OverseerShell<cr>', { desc = 'Run shell command' })
vim.keymap.set('n', '<leader>xl', function()
  -- default_sort already puts running/most-recently-finished tasks first
  local tasks = overseer.list_tasks {}
  if vim.tbl_isempty(tasks) then return vim.notify('No tasks to restart', vim.log.levels.WARN) end
  overseer.run_action(tasks[1], 'restart')
end, { desc = 'Restart last task' })
