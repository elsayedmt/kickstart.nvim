-- markdown-preview.nvim: Live markdown preview in browser
-- Supports KaTeX, Mermaid, PlantUML, Chart.js, and more
-- NOTE: Commented out - requires yarn/npm to build
-- To enable: install yarn (npm install -g yarn) and uncomment below

--[[
return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && yarn install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  ft = { 'markdown' },
  keys = {
    {
      '<leader>mp',
      '<cmd>MarkdownPreviewToggle<cr>',
      desc = '[M]arkdown [P]review toggle',
      ft = 'markdown',
    },
  },
  config = function()
    -- Configuration
    vim.g.mkdp_auto_start = 0 -- Don't auto-start preview
    vim.g.mkdp_auto_close = 1 -- Auto-close preview when leaving markdown buffer
    vim.g.mkdp_refresh_slow = 0 -- Real-time updates (0) vs update on save/insert leave (1)
    vim.g.mkdp_command_for_global = 0 -- Only enable commands in markdown buffers
    vim.g.mkdp_open_to_the_world = 0 -- Don't allow network access
    vim.g.mkdp_browser = '' -- Use default browser
    vim.g.mkdp_echo_preview_url = 0 -- Don't echo preview URL
    vim.g.mkdp_page_title = '「${name}」' -- Preview page title
    vim.g.mkdp_theme = 'dark' -- Use dark theme

    -- Preview options
    vim.g.mkdp_preview_options = {
      mkit = {},
      katex = {},
      uml = {},
      maid = {},
      disable_sync_scroll = 0,
      sync_scroll_type = 'middle',
      hide_yaml_meta = 1,
      sequence_diagrams = {},
      flowchart_diagrams = {},
      content_editable = false,
      disable_filename = 0,
      toc = {},
    }
  end,
}
--]]

return {}
