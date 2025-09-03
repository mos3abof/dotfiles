-- Plugin configuration for remote clipboard support
-- Provides multiple methods for clipboard integration in remote sessions

return {
  -- OSC52 clipboard plugin as a fallback
  {
    "ojroques/nvim-osc52",
    cond = function()
      -- Only load in remote sessions
      return vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil or vim.env.TMUX ~= nil
    end,
    config = function()
      require('osc52').setup({
        max_length = 0,      -- Maximum length of selection (0 for no limit)
        silent = false,      -- Disable message on successful copy
        trim = false,        -- Trim surrounding whitespaces
      })

      -- Keymaps for manual clipboard operations if auto-copy doesn't work
      vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true, desc = "Copy with OSC52" })
      vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true, desc = "Copy line with OSC52" })
      vim.keymap.set('v', '<leader>c', require('osc52').copy_visual, { desc = "Copy selection with OSC52" })
      
      -- Alternative keymaps
      vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true, desc = "Yank with OSC52" })
      vim.keymap.set('n', '<leader>yy', '<leader>y_', { remap = true, desc = "Yank line with OSC52" })
      vim.keymap.set('v', '<leader>y', require('osc52').copy_visual, { desc = "Yank selection with OSC52" })
    end,
  },
}
