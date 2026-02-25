-- Avoid loading the plugin two times
if vim.g.loaded_plugin == 1 then
  return
end
vim.g.loaded_plugin = 1

local FAHonfail = require("FAAAH-on-fail")

vim.api.nvim_create_user_command("FahSoundToggle", function()
  FAHonfail.toggle()
end, { desc = "Activate or Deactivate the sound when a test fails in Neotest" })

vim.api.nvim_create_user_command("FahSoundTest", function()
  FAHonfail.play_sound()
end, { desc = "Try the sound reproduction" })

vim.api.nvim_create_user_command("FahSoundStatus", function()
  FAHonfail.status()
end, { desc = "Muestra si FAAAH-on-fail está activo o desactivado" })
