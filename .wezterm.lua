local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "terminal.sexy"

config.font = wezterm.font("Iosevka")
--config.font = wezterm.font("Iosevka", { weight = "Bold", italic = true })

config.audible_bell = "Disabled"
config.window_decorations = "NONE"
config.default_prog = { "/bin/zsh" }
config.keys = {
	{
		key = "F11",
		mods = "",
		action = wezterm.action.ToggleFullScreen,
	},
}

return config
