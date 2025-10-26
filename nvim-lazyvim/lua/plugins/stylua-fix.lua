-- Fix for stylua GLIBC compatibility issues
-- Configure conform.nvim to use cargo-installed stylua instead of Mason version

return {
  -- Configure conform.nvim to use the cargo-installed stylua
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        stylua = {
          command = vim.fn.expand("~/.cargo/bin/stylua"),
          -- Keep all other stylua settings as default
        },
      },
    },
  },

  -- Prevent Mason from installing stylua (since we use cargo version)
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Remove stylua from the list if it exists
      local filtered = {}
      for _, tool in ipairs(opts.ensure_installed) do
        if tool ~= "stylua" then
          table.insert(filtered, tool)
        end
      end
      opts.ensure_installed = filtered
    end,
  },
}
