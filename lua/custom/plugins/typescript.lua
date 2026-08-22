-- TypeScript 7 (tsgo) language server: `tsc --lsp --stdio`.
-- No plugin needed -- TS 7 speaks LSP natively, so this is a plain vim.lsp client.

local filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' }

-- TS 5's tsc has no --lsp flag, so only accept a project-local tsc when the
-- installed typescript is 7+. tsgo (@typescript/native-preview) always works.
local function ts_major(node_modules)
  local pkg = node_modules .. '/typescript/package.json'
  local ok, decoded = pcall(function() return vim.json.decode(table.concat(vim.fn.readfile(pkg), '\n')) end)
  if not ok or type(decoded) ~= 'table' or type(decoded.version) ~= 'string' then return nil end
  return tonumber(decoded.version:match '^(%d+)')
end

local function resolve_cmd(start)
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

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('tsgo_lsp', { clear = true }),
  pattern = filetypes,
  callback = function(ev)
    local fname = vim.api.nvim_buf_get_name(ev.buf)
    local start = fname ~= '' and vim.fs.dirname(fname) or assert(vim.uv.cwd())

    local cmd = resolve_cmd(start)
    if not cmd then
      vim.notify_once('tsgo: no TypeScript 7 LSP found (pnpm add -D @typescript/native-preview)', vim.log.levels.WARN)
      return
    end

    vim.lsp.start({
      name = 'tsgo',
      cmd = cmd,
      root_dir = vim.fs.root(ev.buf, { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }),
    }, { bufnr = ev.buf })
  end,
})
