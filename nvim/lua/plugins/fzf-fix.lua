-- Fix for fzf-lua version detection issue
-- The system has an old fzf (0.20.0) at /usr/bin/fzf and newer fzf (0.64.0) at ~/.fzf/bin/fzf
-- This configuration ensures fzf-lua uses the newer version

return {
  -- Configure fzf-lua to use the correct fzf binary
  {
    "ibhagwan/fzf-lua",
    optional = true,
    opts = function()
      local fzf_path = vim.fn.expand("~/.fzf/bin/fzf")
      
      return {
        -- Explicitly set the fzf binary path to the newer version
        fzf_bin = fzf_path,
        -- Ensure we're using the correct binary
        fzf_opts = {
          ["--info"] = "inline",
        },
        -- Configure other options as needed
        winopts = {
          height = 0.85,
          width = 0.80,
          preview = {
            default = "bat",
          },
        },
      }
    end,
    config = function(_, opts)
      -- Verify the fzf binary exists and is executable
      local fzf_path = vim.fn.expand("~/.fzf/bin/fzf")
      
      if vim.fn.executable(fzf_path) == 1 then
        -- Get version to confirm it's the right one
        local version_output = vim.fn.system(fzf_path .. " --version 2>/dev/null")
        local version = version_output:match("([%d%.]+)")
        
        if version then
          print("fzf-lua configured to use fzf version " .. version .. " from " .. fzf_path)
        end
        
        -- Ensure the binary path is set
        opts.fzf_bin = fzf_path
        
        -- Setup fzf-lua with our configuration
        require("fzf-lua").setup(opts)
      else
        vim.notify("Warning: fzf binary not found at " .. fzf_path, vim.log.levels.WARN)
      end
    end,
  },
}
