-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Remote clipboard configuration using OSC52
local function is_remote_session()
  return vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil or vim.env.TMUX ~= nil
end

if is_remote_session() then
  -- We're in a remote session, use OSC 52 escape sequences
  vim.opt.clipboard = "unnamedplus"
  
  -- Custom OSC 52 implementation that works better with tmux
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

-- Jsonnet file type configuration
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.jsonnet.TEMPLATE", "*.libsonnet.TEMPLATE" },
  callback = function()
    vim.bo.filetype = "jsonnet"
  end,
})

-- Set up autocmds for jsonnet files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "jsonnet", "libsonnet" },
  callback = function()
    -- Set indentation to 2 spaces
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    
    -- Set line length to 100 characters
    vim.opt_local.textwidth = 100
    vim.opt_local.colorcolumn = "100"
    
    -- Enable auto-formatting options
    vim.opt_local.formatoptions:append("c")  -- Auto-wrap comments
    vim.opt_local.formatoptions:append("r")  -- Continue comments on new line
    vim.opt_local.formatoptions:append("o")  -- Continue comments with 'o' and 'O'
    vim.opt_local.formatoptions:remove("t")  -- Don't auto-wrap text
    
    -- Set comment string for jsonnet
    vim.opt_local.commentstring = "// %s"
    
    -- Enable spell checking for comments and strings
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})
