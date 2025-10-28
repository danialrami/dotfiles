local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ============================================================================
-- COLOR PALETTE DEFINITION
-- Define Catppuccin Mocha color values for consistent theming throughout config
-- ============================================================================
local catppuccin = {
    rosewater = "#f5e0dc",
    flamingo = "#f2cdcd", 
    pink = "#f5c2e7",
    mauve = "#cba6f7",
    red = "#f38ba8",
    maroon = "#eba0ac",
    peach = "#fab387",
    yellow = "#f9e2af",
    green = "#a6e3a1",
    teal = "#94e2d5",
    sky = "#89dceb",
    sapphire = "#74c7ec",
    blue = "#89b4fa",
    lavender = "#b4befe",
    text = "#cdd6f4",
    subtext1 = "#bac2de",
    subtext0 = "#a6adc8",
    overlay2 = "#9399b2",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
    surface2 = "#585b70",
    surface1 = "#45475a",
    surface0 = "#313244",
    base = "#1e1e2e",
    mantle = "#181825",
    crust = "#11111b",
}

-- ============================================================================
-- BASIC TERMINAL CONFIGURATION
-- Core settings for fonts, colors, and basic terminal behavior
-- ============================================================================
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
    "Victor Mono",
    "MesloLGS Nerd Font Mono",
    "Symbols Nerd Font Mono",
})
config.font_size = 12

-- ============================================================================
-- WINDOW AND UI CONFIGURATION
-- Settings for window decorations, tab bar, and overall UI appearance
-- ============================================================================
config.enable_tab_bar = true
config.window_decorations = "RESIZE"  -- Remove TITLE to hide the top title bar
config.window_close_confirmation = 'NeverPrompt'

-- Force macOS to use our custom tab bar colors
config.native_macos_fullscreen_mode = false
config.use_fancy_tab_bar = false  -- Use integrated tab bar for better color control

-- Additional window background settings to ensure consistent theming
config.window_background_opacity = 1.0
config.macos_window_background_blur = 0

-- ============================================================================
-- WINDOW FRAME AND TAB BAR STYLING
-- Configure colors and fonts for the tab bar (no title bar anymore)
-- ============================================================================
config.window_frame = {
    -- Tab bar font configuration
    font = wezterm.font({ family = "Victor Mono", weight = "Bold" }),
    font_size = 11.0,
}

-- ============================================================================
-- TAB BAR COLOR CONFIGURATION
-- Define colors for tabs in different states (active, inactive, hover, new tab)
-- ============================================================================
config.colors = {
    tab_bar = {
        background = catppuccin.base,
        active_tab = {
            bg_color = catppuccin.surface0,
            fg_color = catppuccin.text,
            intensity = "Normal",
            underline = "None",
            italic = false,
            strikethrough = false,
        },
        inactive_tab = {
            bg_color = catppuccin.base,
            fg_color = catppuccin.subtext0,
            intensity = "Normal",
            underline = "None", 
            italic = false,
            strikethrough = false,
        },
        inactive_tab_hover = {
            bg_color = catppuccin.surface1,
            fg_color = catppuccin.text,
            intensity = "Normal",
            underline = "None",
            italic = false,
            strikethrough = false,
        },
        new_tab = {
            bg_color = catppuccin.base,
            fg_color = catppuccin.subtext0,
        },
        new_tab_hover = {
            bg_color = catppuccin.surface1,
            fg_color = catppuccin.text,
        },
    },
}

-- ============================================================================
-- TAB TITLE CUSTOMIZATION
-- Configure what appears in individual tabs
-- Shows just the robot emoji (replacing directory name) with helpful indicators
-- ============================================================================
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    -- Use robot emoji as the main title instead of directory
    local title = "🤖"
    
    -- Add visual indicators for special states
    local indicators = ""
    if tab.active_pane.is_zoomed then
        indicators = indicators .. " 🔍"
    end
    
    -- Show tab index when multiple tabs are open
    local tab_index = ""
    if #tabs > 1 then
        tab_index = string.format("%d: ", tab.tab_index + 1)
    end
    
    return {
        { Text = " " .. tab_index .. title .. indicators .. " " },
    }
end)

-- ============================================================================
-- KEYBOARD SHORTCUTS
-- Custom key bindings for terminal operations
-- ============================================================================
config.keys = {
    -- Close current tab without confirmation (CMD+W)
    {
        key = 'w',
        mods = 'CMD',
        action = wezterm.action.CloseCurrentTab { confirm = false },
    },
}

-- ============================================================================
-- PROCESS CLOSE CONFIRMATION SETTINGS
-- Skip confirmation dialogs when closing tabs running these processes
-- ============================================================================
config.skip_close_confirmation_for_processes_named = {
    'bash', 'sh', 'zsh', 'fish', 'tmux',
}

-- ============================================================================
-- HYPERLINK CONFIGURATION
-- Settings for clickable links in terminal output
-- ============================================================================
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- Add custom regex pattern for additional URL formats
table.insert(config.hyperlink_rules, {
    regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
    format = '$0',
})

-- ============================================================================
-- MOUSE INTERACTION SETTINGS
-- Configure mouse behavior for hyperlinks and other interactions
-- ============================================================================
config.mouse_bindings = {
    -- CTRL+Click to open links
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

-- ============================================================================
-- DEFAULT PROGRAM CONFIGURATION
-- Set tmux to start automatically when opening new terminal instances
-- ============================================================================
config.default_prog = { "/usr/local/bin/tmux" }

return config
