
local wezterm = require 'wezterm';

return {
  color_scheme = "Builtin Solarized Dark",
  -- Define hyperlink rules to match patterns
  hyperlink_rules = {
    -- Match IP addresses
    {
      regex = [[\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b]],
      format = '$0',
      highlight = {underline = true, color = "Red"},
    },
    -- Match MAC addresses
    {
      regex = [[\b[0-9a-fA-F]{2}(:[0-9a-fA-F]{2}){5}\b]],
      format = '$0',
      highlight = {underline = true, color = "Green"},
    },
  },
}
