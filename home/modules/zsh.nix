{lib, ...}: {
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
  };

  programs.zsh.shellAliases = {
    cp = "cp -v";
    rm = "rm -v";
    mv = "mv -v";
  };

  programs.zsh.initExtra = ''
    ZLE_RPROMPT_INDENT=0

    add_path() {
      [ -d $1 ] && export PATH=$1:$PATH
    }

    add_path /opt/homebrew/bin
    add_path $HOME/.deno/bin
    add_path $HOME/.cargo/bin
    add_path $HOME/go/bin
  '';

  programs.starship = {
    enable = lib.mkDefault true;
    enableZshIntegration = true;
  };

  programs.starship.settings = {
    add_newline = false;

    format = "$hostname$directory$nix_shell[λ ](white)";

    hostname.format = "([$hostname](bright-black) )";
    directory.format = "([$path](white) )";
    nix_shell.format = "[*](blue) ";

    right_format = "$git_status$git_branch";

    git_status.format = "([$ahead_behind$all_status](red) )";
    git_branch.format = "[$branch](white)";
  };
}
