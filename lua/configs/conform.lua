local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    javascript = { "prettier" }, javascriptreact = { "prettier" },
    typescript = { "prettier" }, typescriptreact = { "prettier" },
    html = { "prettier" }, css = { "prettier" }, json = { "prettier" },
    yaml = { "prettier" }, markdown = { "prettier" },
    sh = { "shfmt" },
  },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
}
return options
