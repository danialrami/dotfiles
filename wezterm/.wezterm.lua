local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font_with_fallback({
    "Victor Mono",
    "MesloLGS Nerd Font Mono",
    "Symbols Nerd Font Mono",
})

config.font_size = 12

-- Enable tab bar and macOS-style window decorations
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
-- config.window_decorations = "TITLE | RESIZE" -- Adds the macOS title bar with buttons

-- Set window background color to match Catppuccin Mocha
config.window_background_opacity = 1.0 -- Fully opaque window background
config.macos_window_background_blur = 0 -- No blur for a clean look

-- Disable quit confirmation for window close button
config.window_close_confirmation = 'NeverPrompt'

-- Disable quit confirmation for CMD+W
config.keys = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
}

-- Disable quit confirmation for specific processes
config.skip_close_confirmation_for_processes_named = {
  'bash', 'sh', 'zsh', 'fish', 'tmux',
}

-- Hyperlink configuration
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Add custom hyperlink rules
table.insert(config.hyperlink_rules, {
    regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
    format = '$0',
})

-- Mouse bindings for hyperlinks
config.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

-- Start tmux by default
config.default_prog = { "/usr/local/bin/tmux" }

return config