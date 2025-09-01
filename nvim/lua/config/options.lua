-- luacheck: globals vim

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Do not conceal anything
vim.opt.conceallevel = 0

-- Column Settings
vim.opt.colorcolumn = "+1"
vim.opt.textwidth = 120

-- Set formatexpr in order for `gq` to work
vim.opt.formatexpr = "mylang#Format()"

-- No swap files
vim.opt.swapfile = false

-- LSP Server to use for Rust.
-- Set to "bacon-ls" to use bacon-ls instead of rust-analyzer.
-- only for diagnostics. The rest of LSP support will still be
-- provided by rust-analyzer.
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Jsonnet configuration following Databricks style guide
vim.g.jsonnet_fmt_options = "--string-style d --max-width 100 --indent 2 --sort-imports --comment-style //"

-- Additional jsonnet settings for better development experience
vim.g.jsonnet_fold_imports = 1  -- Enable folding of import statements
