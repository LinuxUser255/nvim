return {
  -- Template string plugin
  {
    "axelvc/template-string.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("template-string").setup({
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        jsx_brackets = true,
        remove_template_string = false,
        restore_quotes = {
          normal = [[']],
          jsx = [["]],
        },
      })
    end,
  },

  -- TypeScript error translator
  {
    "dmmulroy/ts-error-translator.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("ts-error-translator").setup()
    end,
  },

  -- TSC plugin
  {
    "dmmulroy/tsc.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("tsc").setup()
    end,
  },
}