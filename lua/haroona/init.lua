require 'haroona.keymap'

-- Indentation: 4-space tabs. shiftwidth = 0 makes `>>`/`<<` follow tabstop,
-- so the two can never drift apart. guess-indent still overrides per-file.
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
