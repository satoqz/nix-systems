{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    coreutils
    curl
    wget
    htop
    neofetch
    ripgrep
    jq

    satoqz.scripts
  ];

  programs.zsh.shellAliases = {
    "top" = "htop";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      set nu
      set ruler
      set expandtab
      set smartindent
      set tabstop=2
      set shiftwidth=2
      set scrolloff=3
      set laststatus=1
      set splitright
      set splitbelow
      set hidden
      set wrap
      set smartcase
      set autoread
      set clipboard=unnamed

      augroup Shape autocmd! autocmd VimLeave * set guicursor=a:ver90 augroup END
    '';
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

      set -g mouse on

      set -g status-style default
      set -g status-position bottom

      set -g status-left ""
      set -g status-right ""

      setw -g window-status-current-format " #I #[fg=brightgreen]#( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' ) "
      setw -g window-status-format " #I #( echo '#W' | sed -E 's/\\.(.*)-wrapped/\\1/' )"
    '';
  };
}
