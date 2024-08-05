
local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.color_scheme = 'terminal.sexy'
config.font =
  wezterm.font('Iosevka', { weight = 'Bold', italic = true })


config.default_prog = { '/bin/zsh' }
config.keys = {
  {
    key = 'F11',
    mods = '',
    action = wezterm.action.ToggleFullScreen,
  },
}

return config
