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
      bufferline = "multiple";
      cursor-shape.insert = "bar";
      indent-guides.render = true;
    };
  };

  # default values: https://github.com/helix-editor/helix/blob/master/languages.toml
  programs.helix.languages =
    [
      {
        name = "nix";
        formatter.command = "alejandra";
        auto-format = true;
      }
    ]
    ++ builtins.map ({
      name,
      id ? name,
    }: {
      inherit name;
      roots = ["deno.json" "deno.jsonc" "tsconfig.json"];
      config = {
        enable = true;
        lint = true;
        unstable = true;
      };
      language-server = {
        command = "deno";
        args = ["lsp"];
        language-id = id;
      };
      auto-format = true;
    }) [
      {name = "javascript";}
      {name = "typescript";}
      {
        name = "jsx";
        id = "javascriptreact";
      }
      {
        name = "tsx";
        id = "typescriptreact";
      }
    ];
}
