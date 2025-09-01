-- Jsonnet configuration for LazyVim
-- Follows Databricks Jsonnet Style Guide
-- Ensures double quotes, 100 char line length, 2-space indent, and proper formatting

return {
  -- Configure conform.nvim for jsonnet formatting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        jsonnetfmt = {
          args = {
            "--string-style", "d",        -- Use double quotes for strings
            "--max-blank-lines", "2",     -- Maximum 2 blank lines (style guide allows 1-2)
            "--indent", "2",              -- 2-space indentation
            "--max-width", "100",         -- 100 character line limit
            "--sort-imports",             -- Sort import statements
            "--comment-style", "//",      -- Use // for comments
            "-"                           -- Read from stdin
          },
        },
      },
      formatters_by_ft = {
        jsonnet = { "jsonnetfmt" },
        libsonnet = { "jsonnetfmt" },   -- Also format .libsonnet files
      },
    },
  },

  -- Configure LSP for jsonnet following Databricks style guide
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        jsonnet_ls = {
          settings = {
            formatting = {
              StringStyle = "double",        -- Use double quotes
              IndentArrayInObject = false,   -- Follow jsonnet fmt defaults
              UseImplicitPlus = true,        -- Allow object composition patterns
              PadArrays = false,             -- No padding in arrays
              PadObjects = true,             -- Pad objects for readability
            },
            ext_vars = {},                   -- Don't use ExtVars (style guide recommends TLAs)
            max_trace = 20,                  -- Reasonable trace depth
          },
        },
      },
    },
  },

  -- Ensure jsonnet treesitter parser is installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "jsonnet" })
      end
    end,
  },

  -- Mason tool installer for jsonnet-language-server and jsonnet
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "jsonnet-language-server",
        "jsonnetfmt",
      })
    end,
  },

  -- Configure autocmds for jsonnet files to follow Databricks style guide
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Set up autocmds for jsonnet files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "jsonnet", "libsonnet" },
        callback = function()
          -- Set indentation to 2 spaces (style guide requirement)
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          vim.opt_local.softtabstop = 2
          vim.opt_local.expandtab = true
          
          -- Set line length to 100 characters (style guide requirement)
          vim.opt_local.textwidth = 100
          vim.opt_local.colorcolumn = "100"
          
          -- Enable auto-formatting on save
          vim.opt_local.formatoptions:append("c")  -- Auto-wrap comments
          vim.opt_local.formatoptions:append("r")  -- Continue comments on new line
          vim.opt_local.formatoptions:append("o")  -- Continue comments with 'o' and 'O'
          vim.opt_local.formatoptions:remove("t")  -- Don't auto-wrap text
          
          -- Set comment string for jsonnet (use // style as per guide)
          vim.opt_local.commentstring = "// %s"
          
          -- Enable spell checking for comments and strings
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
        end,
      })
    end,
  },
}
