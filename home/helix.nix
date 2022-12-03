{ pkgs, lib, inputs, ... }:

let
  namesWithValue = { value, names }:
    builtins.listToAttrs
      (builtins.map (name: { inherit name value; }) names);
in
{
  programs.helix = {
    enable = true;

    package = inputs.helix.packages.${pkgs.system}.default;

    settings = {
      theme = "gruvbox_patched";
      editor = {
        true-color = true;
        cursorline = true;
        color-modes = true;
        bufferline = "multiple";
        cursor-shape.insert = "bar";
        indent-guides.render = true;
      };
    };

    themes.gruvbox_patched = {
      inherits = "gruvbox";
      "ui.bufferline.background".bg = "background";
      "ui.statusline".bg = "background";
    };

    languages =
      let
        withAutoformat = lang: lang // {
          auto-format = true;
        };
        withPrettier = args:
          {
            inherit (args) name;
            formatter = {
              command = "prettier";
              args = lib.optionals (args ? parser) [ "--parser" args.parser ];
            };
          };
      in
      [
        (withAutoformat {
          name = "nix";
          language-server = { command = "rnix-lsp"; };
          formatter = { command = "nixpkgs-fmt"; };
        })
      ]
      ++
      builtins.map withAutoformat
        (builtins.map withPrettier
          (builtins.map
            (name: { inherit name; parser = "typescript"; })
            [ "typescript" "javascript" "tsx" "jsx" ]))
      ++
      builtins.map withAutoformat
        (builtins.map withPrettier
          (builtins.map (name: { inherit name; parser = name; })
            [ "json" "markdown" "html" "css" "yaml" ]))
      ++
      builtins.map withAutoformat [
        { name = "rust"; }
        { name = "go"; }
        { name = "latex"; }
      ];
  };

  programs.zsh.shellAliases = namesWithValue {
    names = [ "vi" "vim" "nvim" ];
    value = "hx";
  };

  home.sessionVariables = namesWithValue {
    names = [ "EDITOR" "VISUAL" ];
    value = "hx";
  };
}
