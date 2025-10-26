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
local function is_remote_session()
  return vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil or vim.env.TMUX ~= nil
end

if is_remote_session() then
  -- We're in a remote session, use OSC 52 escape sequences
  vim.opt.clipboard = "unnamedplus"
  
  -- Custom OSC 52 implementation that works better with tmux and ET
  local function copy_to_clipboard(lines, regtype)
    local text = table.concat(lines, '\n')
    if regtype == 'V' then
      text = text .. '\n'
    end
    
    -- Base64 encode the text
    local b64_text = vim.base64.encode(text)
    
    -- Send OSC 52 sequence
    -- \033]52;c;<base64_encoded_text>\007
    local osc52 = string.format('\027]52;c;%s\007', b64_text)
    
    -- Write directly to terminal
    io.write(osc52)
    io.flush()
  end
  
  -- Override the clipboard provider
  vim.g.clipboard = {
    name = 'osc52',
    copy = {
      ['+'] = copy_to_clipboard,
      ['*'] = copy_to_clipboard,
    },
    paste = {
      ['+'] = function()
        return vim.fn.getreg('+')
      end,
      ['*'] = function()
        return vim.fn.getreg('*')
      end,
    },
  }
  
  -- Auto-copy on yank for better integration
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('OSC52Copy', { clear = true }),
    callback = function()
      if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
        copy_to_clipboard(vim.v.event.regcontents, vim.v.event.regtype)
      end
    end,
  })
else
  -- Local session, use system clipboard
  vim.opt.clipboard = "unnamedplus"
end
