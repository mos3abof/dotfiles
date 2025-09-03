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
-- vim.g.jsonnet_fmt_options = "--string-style d"

-- Additional jsonnet settings for better development experience
-- vim.g.jsonnet_fold_imports = 1  -- Enable folding of import statements

-- Ensure ~/.fzf/bin is prioritized in PATH for Neovim
-- This helps fzf-lua find the correct fzf binary (0.64.0) instead of system fzf (0.20.0)
local fzf_bin_path = vim.fn.expand("~/.fzf/bin")
if vim.fn.isdirectory(fzf_bin_path) == 1 then
  local current_path = vim.env.PATH or ""
  if not current_path:match(fzf_bin_path) then
    vim.env.PATH = fzf_bin_path .. ":" .. current_path
  end
end

-- Configure clipboard for remote sessions
-- This allows copying from Neovim in remote sessions to local macOS clipboard
if vim.env.SSH_TTY then
  -- We're in an SSH session, use OSC 52 escape sequences
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
else
  -- Local session, use system clipboard
  vim.opt.clipboard = "unnamedplus"
end
