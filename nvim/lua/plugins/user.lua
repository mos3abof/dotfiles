-- Custom plugins and configurations
---@type LazySpec
return {

  -- Tmux navigation plugin for seamless pane movement
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown", 
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- Remote clipboard support via OSC52
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

  -- Jsonnet configuration to prevent quote changes on save
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      -- Ensure formatters table exists
      opts.formatters = opts.formatters or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      
      -- Configure jsonnetfmt but don't use it automatically
      opts.formatters.jsonnetfmt = {
        args = {
          "--string-style", "d",        -- Use double quotes for strings
          "--max-blank-lines", "2",     -- Maximum 2 blank lines
          "--indent", "2",              -- 2-space indentation
          "--max-width", "100",         -- 100 character line limit
          "--sort-imports",             -- Sort import statements
          "--comment-style", "//",      -- Use // for comments
          "-"                           -- Read from stdin
        },
      }
      
      -- Explicitly disable formatters for jsonnet files
      opts.formatters_by_ft.jsonnet = {}
      opts.formatters_by_ft.libsonnet = {}
      
      -- Override format_on_save to explicitly disable jsonnet formatting
      local original_format_on_save = opts.format_on_save
      opts.format_on_save = function(bufnr)
        local filetype = vim.bo[bufnr].filetype
        
        -- Explicitly disable formatting for jsonnet files
        if filetype == "jsonnet" or filetype == "libsonnet" then
          return false
        end
        
        -- Call original format_on_save function if it exists
        if type(original_format_on_save) == "function" then
          return original_format_on_save(bufnr)
        elseif original_format_on_save then
          return original_format_on_save
        end
        
        return nil
      end
      
      return opts
    end,
  },

  -- Configure LSP for jsonnet
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
            ext_vars = {},                   -- Don't use ExtVars
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

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
