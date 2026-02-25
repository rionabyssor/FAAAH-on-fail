local M = {}

local function get_plugin_root()
  -- Obtain the absolute path for this file
  local current_file = debug.getinfo(1, "S").source:sub(2)
  -- Go 3 levels up to get the root folder
  return vim.fn.fnamemodify(current_file, ":p:h:h:h")
end

M.config = {
  sound_path = get_plugin_root() .. "/sound/FAH.mp3",
  play_command = { "mpv", "--no-video", "--really-quiet" }
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

M.consumer = function(client)
  client.listeners.results = function(adapter_id, results, partial)
    if partial then return end

    if type(results) ~= "table" then return end

    local test_failed = false

    for _, result in pairs(results) do
      if result.status == "failed" then
        test_failed = true
        break
      end
    end

    if test_failed and M.config.sound_path ~= "" then
      vim.schedule(function()
        if vim.fn.filereadable(M.config.sound_path) == 0 then
          vim.notify("Error: Neotest-FAHsound couldn't find the audio in " .. M.config.sound_path, vim.log.levels.ERROR)
        end
        local cmd = vim.deepcopy(M.config.play_command)
        table.insert(cmd, M.config.sound_path)

        vim.fn.jobstart(cmd, { detach = true, })
      end)
    end
  end

  return {}
end

return M
