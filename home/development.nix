{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    rnix-lsp
    nixpkgs-fmt

    rustc
    rustfmt
    rust-analyzer
    cargo
    cargo-watch
    clippy

    gopls

    nodejs
    nodePackages.yarn
    nodePackages.typescript-language-server
    nodePackages.prettier

    (python3.withPackages
      (ps: with ps; [
        pip
        python-lsp-server
        pylint
      ]))

    texlive.combined.scheme-full
    texlab
    pandoc

    clang-tools
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # darwin has apple clang
    clang
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # on linux use the docker daemon
    docker-client
    docker-compose
    colima
  ];

  home.file.".docker/cli-plugins/docker-compose" = lib.optionalAttrs pkgs.stdenv.isDarwin {
    source = "${pkgs.docker-compose}/bin/docker-compose";
  };

  programs.go = {
    enable = true;
    goPath = ".go";
  };
}
