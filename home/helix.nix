{
  lib,
  config,
  ...
}: {
  programs.helix.enable = lib.mkDefault true;

  programs.helix.settings = {
    theme = "meliora";
    editor = {
      true-color = true;
      cursorline = true;
      color-modes = false;
      bufferline = "always";
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
    ++ lib.mapAttrsToList (name: value: {
      inherit name;

      auto-format = true;

      shebangs = ["deno"];
      roots = ["deno.json" "deno.jsonc" "tsconfig.json"];

      config = {
        enable = true;
        lint = true;
        unstable = true;
      };

      language-server = {
        command = "deno";
        args = ["lsp"];
        language-id = value;
      };
    }) {
      typescript = "typescript";
      javascript = "javascript";
      tsx = "typescriptreact";
      jsx = "javascriptreact";
    };

  home.sessionVariables = lib.mkIf config.programs.helix.enable {
    EDITOR = "hx";
    VISUAL = "hx";
  };
}
