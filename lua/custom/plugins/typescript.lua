-- TypeScript LSP, working across both TS generations:
--   * TS 7 (tsgo / `tsc --lsp --stdio`) when the project (or PATH) has it
--   * ts_ls (typescript-language-server, installed by mason) otherwise
-- tsgo needs no plugin -- TS 7 speaks LSP natively, so it is a plain vim.lsp client.
-- ts_ls is declared in init.lua's `servers` table; the root_dir gate below is what
-- keeps the two from attaching to the same buffer.

local filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' }

-- TS 5's tsc has no --lsp flag, so only accept a project-local tsc when the
-- installed typescript is 7+. tsgo (@typescript/native-preview) always works.
local function ts_major(node_modules)
  local pkg = node_modules .. '/typescript/package.json'
  local ok, decoded = pcall(function() return vim.json.decode(table.concat(vim.fn.readfile(pkg), '\n')) end)
  if not ok or type(decoded) ~= 'table' or type(decoded.version) ~= 'string' then return nil end
  return tonumber(decoded.version:match '^(%d+)')
end

local function find_tsgo_cmd(start)
  local dirs = vim.fs.find('node_modules', { path = start, upward = true, type = 'directory', limit = math.huge })
  for _, node_modules in ipairs(dirs) do
    local tsgo = node_modules .. '/.bin/tsgo'
    if vim.uv.fs_stat(tsgo) then return { tsgo, '--lsp', '--stdio' } end
    local tsc = node_modules .. '/.bin/tsc'
    if vim.uv.fs_stat(tsc) and (ts_major(node_modules) or 0) >= 7 then return { tsc, '--lsp', '--stdio' } end
  end
  if vim.fn.executable 'tsgo' == 1 then return { 'tsgo', '--lsp', '--stdio' } end
  return nil
end

-- Resolution walks the tree on every FileType event, so cache it per directory.
local cmd_cache = {}
local function resolve_cmd(start)
  local hit = cmd_cache[start]
  if hit == nil then
    hit = find_tsgo_cmd(start) or false
    cmd_cache[start] = hit
  end
  return hit or nil
end

local function buf_dir(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  return fname ~= '' and vim.fs.dirname(fname) or assert(vim.uv.cwd())
end

local root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('tsgo_lsp', { clear = true }),
  pattern = filetypes,
  callback = function(ev)
    local cmd = resolve_cmd(buf_dir(ev.buf))
    if not cmd then
      -- No TS 7 here: ts_ls takes the buffer instead (see the root_dir gate below).
      if vim.fn.executable 'typescript-language-server' == 0 then
        vim.notify_once('No TypeScript LSP found (:MasonInstall typescript-language-server, or add @typescript/native-preview)', vim.log.levels.WARN)
      end
      return
    end

    vim.lsp.start({
      name = 'tsgo',
      cmd = cmd,
      root_dir = vim.fs.root(ev.buf, root_markers),
    }, { bufnr = ev.buf })
  end,
})

-- Fallback for TS 5 (and JS) projects. Declining to call `on_dir` prevents ts_ls
-- from starting, which is how tsgo projects avoid getting two servers attached.
vim.lsp.config('ts_ls', {
  root_dir = function(bufnr, on_dir)
    if resolve_cmd(buf_dir(bufnr)) then return end
    local root = vim.fs.root(bufnr, root_markers)
    if root then on_dir(root) end
  end,
})
