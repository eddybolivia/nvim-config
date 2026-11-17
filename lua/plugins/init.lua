return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Vista previa de Markdown en el navegador
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- Treesitter, rama main: reescritura compatible con Neovim 0.12
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local lenguajes_instalados = {
        "python",
        "lua",
        "markdown",
        "markdown_inline",
        "bash",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "yaml",
        "dockerfile",
        "vim",
        "vimdoc",
        "query",
      }
      require("nvim-treesitter").install(lenguajes_instalados)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_resaltado", { clear = true }),
        callback = function(evento)
          local lenguaje = vim.treesitter.language.get_lang(evento.match) or evento.match
          if not vim.treesitter.language.add(lenguaje) then
            return
          end
          vim.treesitter.start(evento.buf, lenguaje)
        end,
      })
    end,
  },

  --
  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

  -- GitHub Copilot: sugerencias automáticas apagadas por defecto
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        keymap = {
          accept = "<M-l>",
          next = "<M-n>",
          prev = "<M-p>",
          dismiss = "<M-d>",
        },
      },
    },
  },
}
