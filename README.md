# FAAAH on Fail
Play the FAAAH sound anytime a test fails! A consumer for neotest that take the fails with humor. Inspired in the [vs code extention](https://marketplace.visualstudio.com/items?itemName=Mastersam.faaaah-on-fail).

It's pretty basic for now, it just works with tests, but I'll be working on extending it's functionality.

Uses mpv as a sound backend, but it can be changed in the configuration as well as the sound it plays when tests fails.

## 📦 Installation
**[lazy.nvim](https://github.com/folke/lazy.nvim)**

Add the plugin to your Neotest dependencies and inject it into the consumers table:
```lua
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      -- Install the plugin
      "rionabyssor/FAAAH-on-fail", 
    },
    config = function()
      require("neotest").setup({
        adapters = {
          -- Your adapters here...
        },
        -- Inject the consumer into neotest
        consumers = {
          FAHonfail = require("FAAAH-on-fail").consumer,
        }
      })
    end
  }
}
```

**[packer.nvim](https://github.com/wbthomason/packer.nvim)**

```lua
use {
  "nvim-neotest/neotest",
  requires = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "rionabyssor/FAAAH-on-fail", -- Install the plugin
  },
  config = function()
    require("neotest").setup({
      adapters = {
       -- Your adapters here...
      },
      consumers = {
       FAHonfail = require("FAAAH-on-fail").consumer,
      }
    })
  end
}
```
## ⚙️ Configuration
The plugin comes with a default configuration already, but it is very simple, just 2 variables you need to change.
```lua
require("neotest-FAHsound").setup({
    -- Absolute path to your audio file. 
    sound_path = get_plugin_root() .. "/sound/FAH.mp3",
    -- The CLI command to execute the audio file.
    play_command = { "mpv", "--no-video", "--really-quiet" }
})
```

## How it works
Theres no much magic behind this plugin, just write some tests in your favorite language and then just run neotest and then if a test fails, it will automatically reproduce the sound.

## Todo
- **Multiple built-in sounds**
- **Volume control**
- **Failure messages**
- **Cross platform**
- **Build failure detection**
- **Runtime failure detection**
- **Commands to enable/disable the plugin and for test sounds**
