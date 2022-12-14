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

    # italic comments
    comment.modifiers = ["italic"];
    comment.fg = "dark_green";

    # clean statusline
    "ui.statusline".bg = "background";
    "ui.statusline".fg = "dark_gray";
    "ui.statusline.inactive".bg = "background";
    "ui.statusline.inactive".fg = "dark_gray";

    # clean bufferline
    "ui.bufferline".bg = "background";
    "ui.bufferline.active".bg = "background";
    "ui.bufferline".fg = "dark_gray";

    # remove white borders
    "ui.window".fg = "dark_gray";
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
