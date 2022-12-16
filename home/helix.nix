{
  lib,
  config,
  ...
}: {
  programs.helix.enable = lib.mkDefault true;

  home.sessionVariables = lib.mkIf config.programs.helix.enable {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs.helix.settings = {
    theme = "gruvbox";
    editor = {
      true-color = true;
      cursorline = true;
      color-modes = true;
      bufferline = "always";
      cursor-shape.insert = "bar";
      indent-guides.render = true;
    };
  };

  # default values: https://github.com/helix-editor/helix/blob/master/languages.toml
  programs.helix.languages = lib.mapAttrsToList (name: value:
    value
    // {
      inherit name;
    }) rec {
    nix = {
      formatter.command = "alejandra";
      auto-format = true;
    };

    latex = {
      rulers = [120];
    };

    typescript = {
      shebangs = ["deno"];
      roots = ["deno.json" "deno.jsonc" "tsconfig.json"];

      language-server = {
        command = "deno";
        args = ["lsp"];
        language-id = "typescript";
      };

      config = {
        enable = true;
        lint = true;
        unstable = true;
      };

      auto-format = true;
    };

    javascript =
      typescript
      // {
        language-server = {
          command = "deno";
          args = ["lsp"];
          language-id = "javascript";
        };
      };

    tsx =
      typescript
      // {
        language-server = {
          command = "deno";
          args = ["lsp"];
          language-id = "typescriptreact";
        };
      };

    jsx =
      typescript
      // {
        language-server = {
          command = "deno";
          args = ["lsp"];
          language-id = "javascriptreact";
        };
      };
  };
}
