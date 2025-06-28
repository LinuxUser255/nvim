-- Turning on Tabnine autocomplete.
return {
  "tzachar/cmp-tabnine",
  build = "./install.sh",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "codota/tabnine-nvim",
  },
  config = function()
    local tabnine = require('cmp_tabnine.config')
    tabnine:setup({
      max_lines = 1000,
      max_num_results = 5,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = '..',
      ignored_file_types = {},
      show_prediction_strength = true
    })

    -- This will be called after nvim-cmp is fully set up
    -- to add Tabnine as a source
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Wait a moment to ensure nvim-cmp is fully loaded
        vim.defer_fn(function()
          local cmp = require('cmp')
          local config = cmp.get_config()

          -- Add Tabnine as a source if it's not already there
          local has_tabnine = false
          for _, source in ipairs(config.sources) do
            if source.name == "tabnine" then
              has_tabnine = true
              break
            end
          end

          if not has_tabnine then
            table.insert(config.sources, { name = "tabnine", priority = 900 })
            cmp.setup(config)
            print("Tabnine source added to nvim-cmp")
          end
        end, 500)
      end,
      once = true
    })
  end
}
