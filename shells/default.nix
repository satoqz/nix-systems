{pkgs}:
with pkgs; rec {
  default = nix;

  nix = pkgs.mkShell {
    packages = [
      rnix-lsp
      alejandra
      gnumake
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
    ];
  };

  node = mkShell {
    packages = [
      nodejs
      nodePackages.yarn
      nodePackages.pnpm
      nodePackages.prettier
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
