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
    theme = "base16_transparent";
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

  programs.helix.themes.melange = {
    palette = {
      bg = "#2A2520";
      fg = "#ECE1D7";

      black = "#352F2A";
      red = "#B65C60";
      green = "#78997A";
      yellow = "#E49B5D";
      blue = "#697893";
      magenta = "#B380B0";
      cyan = "#86A3A3";
      white = "#C1A78E";

      dark-black = "#2A2520";
      dark-red = "#7D2A2F";
      dark-green = "#1F3521";
      dark-yellow = "#8E733F";
      dark-blue = "#243146";
      dark-magenta = "#462445";
      dark-cyan = "#213433";
      dark-white = "#A38D78";

      bright-black = "#4D453E";
      bright-red = "#F17C64";
      bright-green = "#99D59D";
      bright-yellow = "#EBC06D";
      bright-blue = "#9AACCE";
      bright-magenta = "#CE9BCB";
      bright-cyan = "#88B3B2";
      bright-white = "#ECE1D7";
    };

    "attribute" = "fg";
    "type" = "fg";
    "type.builtin" = "fg";
    "constructor" = "fg";
    "constant" = "fg";
    "constant.builtin" = "fg";
    "constant.builtin.boolean" = "fg";
    "constant.character" = "fg";
    "constant.character.escape" = "fg";
    "constant.numeric" = "fg";
    "constant.numeric.integer" = "fg";
    "constant.numeric.float" = "fg";
    "string" = "fg";
    "string.regexp" = "fg";
    "string.special" = "fg";
    "string.special.path" = "fg";
    "string.special.url" = "fg";
    "string.special.symbol" = "fg";
    "comment" = "fg";
    "comment.line" = "fg";
    "comment.block" = "fg";
    "comment.block.documentation" = "fg";
    "variable" = "fg";
    "variable.builtin" = "fg";
    "variable.parameter" = "fg";
    "variable.other" = "fg";
    "variable.other.member" = "fg";
    "label" = "fg";

    "punctuation" = "fg";
    "punctuation.delimiter" = "fg";
    "punctuation.bracket" = "fg";
    "punctuation.special" = "fg";

    "keyword" = "fg";
    "keyword.control" = "fg";
    "keyword.control.conditional" = "fg";
    "keyword.control.repeat" = "fg";
    "keyword.control.import" = "fg";
    "keyword.control.return" = "fg";
    "keyword.control.exception" = "fg";
    "keyword.operator" = "fg";
    "keyword.directive" = "fg";
    "keyword.function" = "fg";
    "keyword.storage" = "fg";
    "keyword.storage.type" = "fg";
    "keyword.storage.modifier" = "fg";

    "operator" = "fg";

    "function" = "fg";
    "function.builtin" = "fg";
    "function.method" = "fg";
    "function.macro" = "fg";
    "function.special" = "fg";

    "tag" = "fg";
    "namespace" = "fg";

    "markup" = "fg";
    "markup.heading" = "fg";
    "markup.heading.marker" = "fg";
    "markup.heading.1" = "fg";
    "markup.heading.2" = "fg";
    "markup.heading.3" = "fg";
    "markup.heading.4" = "fg";
    "markup.heading.5" = "fg";
    "markup.heading.6" = "fg";
    "markup.list" = "fg";
    "markup.list.unnumbered" = "fg";
    "markup.list.numbered" = "fg";
    "markup.bold" = "fg";
    "markup.italic" = "fg";
    "markup.link" = "fg";
    "markup.link.url" = "fg";
    "markup.link.label" = "fg";
    "markup.link.text" = "fg";
    "markup.quote" = "fg";
    "markup.raw.inline" = "fg";
    "markup.raw.block" = "fg";

    "diff" = "fg";
    "diff.plus" = "fg";
    "diff.minus" = "fg";
    "diff.delta" = "fg";
    "diff.delta.moved" = "fg";

    "ui.background".bg = "bg";
    "ui.background.separator".fg = "black";

    "ui.cursor" = "fg";
    "ui.cursor.insert" = "fg";
    "ui.cursor.select" = "cyan";
    "ui.cursor.match" = "yellow";
    "ui.cursor.primary" = "white";

    "ui.gutter".bg = "bg";
    "ui.gutter.selected".bg = "black";

    "ui.linenr" = "black";
    "ui.linenr.selected" = {
      fg = "bright-black";
      modifiers = ["bold"];
    };

    "ui.statusline" = {
      bg = "black";
      fg = "fg";
    };
    "ui.statusline.inactive" = {
      bg = "black";
      fg = "fg";
    };
    "ui.statusline.normal" = {
      bg = "black";
      fg = "fg";
    };
    "ui.statusline.insert" = {
      bg = "black";
      fg = "fg";
    };
    "ui.statusline.select" = {
      bg = "black";
      fg = "fg";
    };
    "ui.statusline.separator" = "dark-white";

    "ui.popup".bg = "bg";
    "ui.popup.info".bg = "bg";
    "ui.window".bg = "bg";
    "ui.help".bg = "bg";

    "ui.text" = "fg";
    "ui.text.focus" = "fg";
    "ui.text.info" = "fg";

    "ui.virtual.ruler".bg = "dark-black";
    "ui.virtual.whitespace".fg = "bright-black";
    "ui.virtual.indent-guide".fg = "bright-black";

    "ui.menu".bg = "bg";
    "ui.menu.selected".bg = "brigth-black";
    "ui.menu.scroll".bg = "black";

    "ui.selection".bg = "bright-blue";
    "ui.selection.primary".bg = "bright-blue";

    "ui.cursorline.primary".bg = "black";
    "ui.cursorline.secondary".bg = "black";

    "ui.cursorcolumn.primary".bg = "black";
    "ui.cursorcolumn.secondary".bg = "black";

    "hint" = "magenta";
    "info" = "cyan";
    "warning" = "yellow";
    "error" = "red";

    "diagnostic.hint".underline = {
      color = "magenta";
      style = "curl";
    };
    "diagnostic.info".underline = {
      color = "cyan";
      style = "curl";
    };
    "diagnostic.warning".underline = {
      color = "yellow";
      style = "curl";
    };
    "diagnostic.error".underline = {
      color = "red";
      style = "curl";
    };
  };
}
