local M = {}

local function get_plugin_root()
  -- Obtain the absolute path for this file
  local current_file = debug.getinfo(1, "S").source:sub(2)
  -- Go 3 levels up to get the root folder
  return vim.fn.fnamemodify(current_file, ":p:h:h:h")
end

local state_file = vim.fn.stdpath("data") .. "/fahsound_state.json"

-- function to load the state of the plugin via a json file
local function load_state()
  if vim.fn.filereadable(state_file) == 1 then
    local lines = vim.fn.readfile(state_file)
    if #lines > 0 then
      local ok, state = pcall(vim.json.decode, lines[1])
      if ok and type(state) == "table" and state.enabled ~= nil then
        return state.enabled
      end
    end
  end
  return true -- Default state if the file doesn't exists
end

local function save_state(enabled)
  local state = vim.json.encode({ enabled = enabled })
  vim.fn.writefile({ state }, state_file)
end

M.config = {
  sound_path = get_plugin_root() .. "/sound/FAH.mp3",
  play_command = { "mpv", "--no-video", "--really-quiet" },
  enabled = load_state()
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- toggle the status of the plugin
function M.toggle()
  M.config.enabled = not M.config.enabled
  save_state(M.config.enabled)
  local estado = M.config.enabled and "Active" or "Inactive"
  vim.notify("FAAAHonsound: " .. estado, vim.log.levels.INFO)
end

-- Check the status of the plugin
function M.status()
  local estado = M.config.enabled and "Active" or "Inactive"
  print("Estado de FAAAHonsound: " .. estado)
end

-- Reproduce the sound that is configured asynchronously
function M.play_sound()
  if vim.fn.filereadable(M.config.sound_path) == 0 then
    vim.notify("Error: Neotest-FAHsound couldn't find the audio in " .. M.config.sound_path, vim.log.levels.ERROR)
    return
  end
  local cmd = vim.deepcopy(M.config.play_command)
  table.insert(cmd, M.config.sound_path)
  vim.fn.jobstart(cmd, { detach = true })
end

M.consumer = function(client)
  client.listeners.results = function(adapter_id, results, partial)
    if partial then return end

    if type(results) ~= "table" then return end

    if not M.config.enabled then return end

    local test_failed = false

    for _, result in pairs(results) do
      if result.status == "failed" then
        test_failed = true
        break
      end
    end

    if test_failed and M.config.sound_path ~= "" then
      vim.schedule(function()
        M.play_sound()
      end)
    end
  end

  return {}
end

return M
