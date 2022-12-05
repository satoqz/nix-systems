{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.home.devtools = {
    nix = mkEnableOption "Nix tooling";
    rust = mkEnableOption "Rust tooling";
    node = mkEnableOption "Node.js tooling";
    docker = mkEnableOption "Docker tooling";
    python = mkEnableOption "Python tooling";
    go = mkEnableOption "Golang tooling";
    latex = mkEnableOption "LaTeX tooling";
    c = mkEnableOption "C tooling";
  };

  config = let
    isDarwin = pkgs.stdenv.isDarwin;
    isLinux = pkgs.stdenv.isLinux;
    devtools = config.home.devtools;
  in {
    home.packages = with pkgs;
      optionals devtools.nix [
        rnix-lsp
        alejandra
      ]
      ++ lib.optionals devtools.rust [
        rustc
        rustfmt
        rust-analyzer
        cargo
        cargo-watch
        clippy
        taplo
      ]
      ++ optionals devtools.node [
        nodejs
        nodePackages.yarn
        nodePackages.typescript-language-server
        nodePackages.prettier
      ]
      ++ optionals devtools.docker [
        nodePackages.yaml-language-server
        nodePackages.dockerfile-language-server-nodejs
      ]
      ++ optionals (devtools.docker && isDarwin) [
        docker-client
        docker-compose
        colima
      ]
      ++ optionals devtools.python [
        (python3.withPackages
          (ps:
            with ps; [
              pip
              python-lsp-server
              pylint
            ]))
      ]
      ++ optionals devtools.go [
        gopls
      ]
      ++ optionals devtools.latex [
        texlive.combined.scheme-full
        texlab
        pandoc
      ]
      ++ optionals devtools.c [
        clang-tools
      ]
      ++ optionals (devtools.c && isLinux) [
        clang
        gcc
      ];

    home.file.".docker/cli-plugins/docker-compose" = mkIf (devtools.docker && isDarwin) {
      source = "${pkgs.docker-compose}/bin/docker-compose";
    };

    programs.go = mkIf devtools.go {
      enable = true;
      goPath = ".go";
    };
  };
}
