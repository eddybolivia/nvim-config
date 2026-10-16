require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Markdown: abrir y cerrar la vista previa en el navegador
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown: vista previa" })
