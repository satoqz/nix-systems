{
  inputs,
  pkgs,
  ...
}: {
  programs.helix.enable = true;

  programs.helix.package = inputs.helix.packages.${pkgs.system}.default;

  programs.zsh.shellAliases = {
    vi = "hx";
    vim = "hx";
    nvim = "hx";
  };

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.helix.settings = {
    theme = "gruvbox";
    editor = {
      true-color = true;
      cursorline = true;
      color-modes = true;
      cursor-shape.insert = "bar";
      indent-guides.render = true;
    };
  };

  # default values: https://github.com/helix-editor/helix/blob/master/languages.toml
  programs.helix.languages = [
    {
      name = "nix";
      language-server.command = "nil";
      config.nil.formatting.command = ["alejandra"];
      auto-format = true;
    }
  ];
}
