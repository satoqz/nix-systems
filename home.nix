{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.hash.enable = lib.mkEnableOption "secret hash program";

  config = {
    home.packages = with pkgs;
      [
        coreutils
        curl
        wget
        htop
        gitui
        neofetch
        ripgrep
        jq

        satoqz.scripts
      ]
      ++ lib.optionals stdenv.isDarwin [
        docker-client
        docker-compose
        colima
      ]
      ++ lib.optional config.programs.hash.enable satoqz.hash;

    programs.zsh = {
      enable = true;
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      dotDir = ".config/zsh";
    };

    programs.zsh.shellAliases = {
      vi = "hx";
      vim = "hx";
      nvim = "hx";
      cp = "cp -v";
      rm = "rm -v";
      mv = "mv -v";
      top = "htop";
      tmux = "env TERM=screen-256color tmux";
      finder =
        lib.mkIf pkgs.stdenv.isDarwin "open -a Finder .";
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.starship.settings = {
      add_newline = false;
      format = "$username@$hostname$nix_shell ";
      right_format = "$git_status$directory$git_branch";
      username = {
        show_always = true;
        format = "[$user](black)";
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname](black)";
      };
      directory.format = "[$path](green)";
      git_status.format = " ([<](black)[$all_status$ahead$behind]($style)[>](black)) ";
      git_branch.format = " [# $branch(:$remote_branch)](black)";
      nix_shell.format = " [<](black)[nix]($style)[>](black)";
    };

    home.file.".docker/cli-plugins/docker-compose" = lib.mkIf pkgs.stdenv.isDarwin {
      source = "${pkgs.docker-compose}/bin/docker-compose";
    };

    programs.lsd = {
      enable = true;
      enableAliases = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.git = {
      enable = true;
      userEmail = "satoqz@pm.me";
      userName = "satoqz";
      extraConfig.init.defaultBranch = "main";
    };

    programs.gh = {
      enable = true;
      enableGitCredentialHelper = true;
      settings = {
        git_protocol = "https";
        prompt = "enabled";
      };
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 100000;
      disableConfirmationPrompt = true;
      terminal = "xterm-256color";
      extraConfig = ''
        set -sa terminal-overrides ",xterm-256color:RGB"

        set -g renumber-windows on

        set -g mouse on

        set -g pane-active-border-style fg=black
        set -g pane-border-style fg=black

        set -g status-style default
        set -g status-position bottom

        set -g status-left ""
        set -g status-right "#[fg=gray]#H #[fg=gray][#[fg=brightred]#S#[fg=black]]"

        setw -g window-status-current-format "#[fg=black][#[fg=brightgreen]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )#[fg=black]] "
        setw -g window-status-format "#[fg=black]#[fg=gray][#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )#[fg=black]] "
      '';
    };

    programs.helix.enable = true;

    programs.helix.package = inputs.helix.packages.${pkgs.system}.default;

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
    programs.helix.languages = [
      {
        name = "nix";
        formatter.command = "alejandra";
        auto-format = true;
      }
    ];
  };
}
