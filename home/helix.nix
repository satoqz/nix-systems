{
  lib,
  config,
  ...
}: {
  programs.helix.enable = lib.mkDefault true;

  programs.helix.settings = {
    theme = "dark_plus_patched";
    editor = {
      true-color = true;
      cursorline = true;
      color-modes = false;
      bufferline = "always";
      cursor-shape.insert = "bar";
      indent-guides.render = true;
    };
  };

  programs.helix.themes.dark_plus_patched = {
    inherits = "dark_plus";
    "ui.statusline".bg = "dark_gray3";
    "ui.statusline.inactive".bg = "dark_gray3";
    "ui.bufferline".bg = "background";
    "ui.bufferline.active".bg = "dark_gray4";
  };

  # default values: https://github.com/helix-editor/helix/blob/master/languages.toml
  programs.helix.languages = [
    {
      name = "nix";
      formatter.command = "alejandra";
      auto-format = true;
    }
  ];

  home.sessionVariables = lib.mkIf config.programs.helix.enable {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.zsh.shellAliases = lib.mkIf config.programs.helix.enable {
    vi = "hx";
    vim = "hx";
    nvim = "hx";
  };
}
