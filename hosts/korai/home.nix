{pkgs, ...}: {
  home.devtools = {
    nix = true;
    rust = true;
    node = true;
    deno = true;
    docker = true;
    python = true;
    go = true;
    latex = true;
    c = true;
  };

  home.packages = [
    pkgs.satoqz.hash
  ];
}
