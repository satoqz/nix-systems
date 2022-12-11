{
  lib,
  config,
  ...
}: {
  programs.helix.enable = lib.mkDefault true;

  programs.helix.settings = {
    theme = "gruvbox";
    editor = {
      true-color = true;
      cursorline = true;
      color-modes = true;
      bufferline = "multiple";
      cursor-shape.insert = "bar";
      indent-guides.render = true;
    };
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
