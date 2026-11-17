require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Markdown: abrir y cerrar la vista previa en el navegador
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown: vista previa" })

-- Python: ejecutar el archivo actual y mostrar la salida en un panel lateral
local nombre_panel = "salida_python"
local ultimo_archivo_python = nil
local ventana_codigo = nil
local guicursor_original = nil

local function cerrar_panel_python()
  local buffer_salida = vim.fn.bufnr(nombre_panel)
  if buffer_salida == -1 then
    return
  end
  local ventana_panel = vim.fn.bufwinid(buffer_salida)
  if ventana_panel ~= -1 then
    vim.api.nvim_win_close(ventana_panel, true)
  end
  if ventana_codigo and vim.api.nvim_win_is_valid(ventana_codigo) then
    vim.api.nvim_set_current_win(ventana_codigo)
  end
end

local function ejecutar_archivo_python()
  local es_archivo_python = vim.bo.filetype == "python" and vim.bo.buftype == ""

  if es_archivo_python then
    vim.cmd "update"
    ultimo_archivo_python = vim.fn.expand "%:p"
    ventana_codigo = vim.api.nvim_get_current_win()
  else
    return
  end

  local resultado = vim.system({ "python3", ultimo_archivo_python }, { text = true }):wait(10000)

  local texto_salida = (resultado.stdout or "") .. (resultado.stderr or "")
  local lineas_salida = vim.split(texto_salida, "\n", { trimempty = true })
  if resultado.code ~= 0 then
    table.insert(lineas_salida, "")
    table.insert(lineas_salida, "[Error: código " .. resultado.code .. "]")
  end
  table.insert(lineas_salida, "")

  local buffer_salida = vim.fn.bufnr(nombre_panel)
  if buffer_salida == -1 then
    buffer_salida = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buffer_salida, nombre_panel)
    vim.keymap.set("n", "<Esc>", cerrar_panel_python, { buffer = buffer_salida, desc = "Cerrar panel de salida" })
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buffer_salida,
      callback = function()
        if guicursor_original == nil then
          guicursor_original = vim.o.guicursor
        end
        vim.o.guicursor = guicursor_original .. ",n:block-blinkwait300-blinkon400-blinkoff250"
      end,
    })
    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = buffer_salida,
      callback = function()
        vim.o.guicursor = guicursor_original
      end,
    })
  end

  vim.api.nvim_buf_set_lines(buffer_salida, 0, -1, false, lineas_salida)

  local ventana_panel = vim.fn.bufwinid(buffer_salida)
  if ventana_panel == -1 then
    vim.cmd "botright vsplit"
    ventana_panel = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(ventana_panel, buffer_salida)
    vim.cmd("vertical resize " .. math.floor(vim.o.columns / 3))
    vim.wo[ventana_panel].number = false
    vim.wo[ventana_panel].relativenumber = false
  end
  vim.api.nvim_win_set_cursor(ventana_panel, { 1, 0 })
  vim.api.nvim_set_current_win(ventana_codigo)
end

map({ "n", "i" }, "<C-CR>", ejecutar_archivo_python, { desc = "Python: ejecutar archivo actual" })

-- Copilot: encender o apagar las sugerencias automáticas en el archivo actual
map("n", "<leader>ai", function()
  require("copilot.suggestion").toggle_auto_trigger()
end, { desc = "Copilot: sugerencias automáticas" })
