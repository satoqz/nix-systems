pkgs:
with pkgs; {
  default = mkShell {
    packages = [
      nil
      alejandra
      gnumake
    ];
  };

  nix = mkShell {
    packages = [
      nil
      alejandra
    ];
  };

  c = mkShell {
    packages = [
      gcc
      clang
      clang-tools
      gnumake
    ];
    shellInit = ''
      export CFLAGS="-Wall -Wextra"
    '';
  };

  go = mkShell {
    packages = [
      go
      gopls
      go-tools
    ];
    GOPATH = "$HOME/.go";
  };

  rust = mkShell {
    packages = [
      rustc
      rustfmt
      rust-analyzer
      cargo
      cargo-watch
      clippy
      taplo
    ];
  };

  node = mkShell {
    packages = [
      nodejs
      nodePackages.yarn
      nodePackages.pnpm
      nodePackages.prettier
      nodePackages.typescript-language-server
    ];
  };

  deno = mkShell {
    packages = [deno];
  };

  python = mkShell {
    packages = [
      (python3.withPackages
        (ps: [
          ps.pip
          ps.python-lsp-server
          ps.pylint
        ]))
    ];
  };

  latex = mkShell {
    packages = [
      texlive.combined.scheme-full
      texlab
      pandoc
    ];
  };
}
