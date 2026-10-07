require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html", "cssls",                        -- Web
  "pyright", "ruff",                      -- Python
  "ts_ls", "eslint",                      -- JavaScript, TypeScript y React
  "dockerls", "docker_compose_language_service", -- Docker
  "yamlls", "bashls",                     -- YAML y Bash
  "terraformls", "ansiblels",             -- Infraestructura como código
}
vim.lsp.enable(servers)
