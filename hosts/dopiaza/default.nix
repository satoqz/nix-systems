{ lib, self, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  virtualisation.docker.enable = true;

  users.users.${user} = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6eAwwmeujQ8phKn57VbgxUAHvE8Z1XraqCYlzr9IAp8ea+Sx+efhxLk1XveHJispz0zkP2SgNCFDsQhuDDpJXejhiIpsnr6PlNzrRNTggQzurESkM/OTS+aaeNLd4vncEDxzPf4zWxHgt3ZN4UXlOJHzXgp4UWE+sWXAOdwI1L5ZaOWb6R8XuipmNlBJW7QxBhWPJylxsQW5XsMb/aweW5JHVxqGaIhA8Dui3onB9RvqvNyZXIZx29A9CbAbZYZwfZ3o43RrvGNMYeVyMT+LP8TgQY7X7tHk2aplDugabO46T1J5+z9Hq8GFjQ8dddk/JbPqEQhcH0718C7AH94ieL3s5KIZm1Thp7oVlJYXEMxldF6BfOXzjeE05wR9E63lnKqLicijbJLxr5Tvdo0R2y/P0ImVzXZY3MgLRe1z3qQb1sVSwg3O1q5s6BJ2fi1cCXtV6noWzy9cHivWxOR3aPiwIQBN5xWA3eeSImjAlmZTKOomC3SIFfzZYb+r5sPE="
    ];

    extraGroups = [ "docker" ];
  };

  networking.domain = "trench.world";

  system.autoUpgrade = {
    enable = true;
    flake = self.outPath;
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
      "-L"
    ];
  };
}