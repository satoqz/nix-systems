{pkgs, ...}: {
  programs.alacritty.settings = {
    live_config_reload = true;
    selection.save_to_clipboard = true;
    cursor.style.shape = "Beam";

    window = {
      title = "";
      dynamic_padding = true;
      dimensions = {
        columns = 160;
        lines = 50;
      };
      padding = {
        x = 4;
        y = 4;
      };
    };

    font = {
      size = 14;

      normal = {
        family = "JetBrainsMono Nerd Font";
        style = "Regular";
      };

      bold = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold";
      };

      italic = {
        family = "JetBrainsMono Nerd Font";
        style = "Italic";
      };

      bold_italic = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold Italic";
      };
    };

    colors = {
      primary = {
        background = "#1e1e1e";
        foreground = "#cccccc";
      };

      cursor = {
        text = "#000000";
        cursor = "#cccccc";
      };

      selection = {
        text = "#ffffff";
        background = "#555555";
      };

      normal = {
        black = "#717171";
        red = "#e94a51";
        green = "#45d38a";
        yellow = "#f2f84a";
        blue = "#4e8ae9";
        magenta = "#d26ad6";
        cyan = "#49b7da";
        white = "#e5e5e5";
      };

      bright = {
        black = "#717171";
        red = "#e94a51";
        green = "#45d38a";
        yellow = "#f2f84a";
        blue = "#4e8ae9";
        magenta = "#d26ad6";
        cyan = "#49b7da";
        white = "#e5e5e5";
      };
    };

    key_bindings = [
      {
        key = "P";
        mods = "Command|Control";
        action = "Paste";
      }
      {
        key = "C";
        mods = "Command|Control";
        action = "Copy";
      }
    ];
  };
}
