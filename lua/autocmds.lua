require "nvchad.autocmds"

-- Markdown: evitar el error de Treesitter en Neovim 0.12.
-- La rama antigua de nvim-treesitter choca con las "inyecciones"
-- que colorean los bloques de código dentro del Markdown.
vim.treesitter.query.set("markdown", "injections", "")
