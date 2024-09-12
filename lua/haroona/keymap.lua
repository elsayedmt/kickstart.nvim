local wk = require 'which-key'
local chatgpt = require 'chatgpt'

wk.add {
  group = '[C]hatGPT',
  { '<leader>C', group = '[C]hat GPT' }, -- group
  { '<leader>Ce', '<cmd>ChatGPTEditWithInstruction<CR>', desc = '[E]dit with instructions', mode = 'n' },
  { '<leader>Cg', '<cmd>ChatGPTRun grammar_correction<CR>', desc = '[G]rammar Correction', mode = { 'n', 'v' } },
  { '<leader>Ct', '<cmd>ChatGPTRun translate<CR>', desc = '[T]ranslate', mode = { 'n', 'v' } },
  { '<leader>Ck', '<cmd>ChatGPTRun keywords<CR>', desc = '[K]eywords', mode = { 'n', 'v' } },
  { '<leader>Cd', '<cmd>ChatGPTRun docstring<CR>', desc = '[D]ocstring', mode = { 'n', 'v' } },
  { '<leader>Ca', '<cmd>ChatGPTRun add_tests<CR>', desc = '[A]dd Tests', mode = { 'n', 'v' } },
  { '<leader>Co', '<cmd>ChatGPTRun optimize_code<CR>', desc = '[O]ptimize Code', mode = { 'n', 'v' } },
  { '<leader>Cs', '<cmd>ChatGPTRun summarize<CR>', desc = '[S]ummarize', mode = { 'n', 'v' } },
  { '<leader>Cf', '<cmd>ChatGPTRun fix_bugs<CR>', desc = '[F]ix Bugs', mode = { 'n', 'v' } },
  { '<leader>Cx', '<cmd>ChatGPTRun explain_code<CR>', desc = 'E[x]plain Code', mode = { 'n', 'v' } },
  { '<leader>Cr', '<cmd>ChatGPTRun roxygen_edit<CR>', desc = '[R]oxygen Edit', mode = { 'n', 'v' } },
  { '<leader>Cl', '<cmd>ChatGPTRun code_readability_analysis<CR>', desc = 'Code Readabi[l]ity Analysis', mode = { 'n', 'v' } },
}

-- wk.add({
--   group = 'Mohamed',
--   mode = 'n',
--   { '<leader>M', group = 'Mohamed' },
--   {
--     '<leader>Me',
--     function()
--       print 'Hi!'
--     end,
--   },
-- }, { mode = 'n' })
