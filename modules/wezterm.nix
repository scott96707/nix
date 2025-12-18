{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    
    # This automatically handles the symlinking of the config file
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      -- 1. Appearance
      config.color_scheme = 'Tokyo Night'
      config.font = wezterm.font 'JetBrains Mono'
      config.font_size = 14.0

      -- 2. Window Settings
      config.window_background_opacity = 0.95
      config.window_decorations = "RESIZE"
      config.hide_tab_bar_if_only_one_tab = true

      -- 3. Keybindings
      config.keys = {
        { key = 'LeftArrow', mods = 'OPT', action = wezterm.action.SendString '\x1bb' },
        { key = 'RightArrow', mods = 'OPT', action = wezterm.action.SendString '\x1bf' },
      }

      return config
    '';
  };
}
