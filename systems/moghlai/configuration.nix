{
  inputs,
  pkgs,
  modules,
  user,
  ...
}: {
  imports = with modules; [ssh autonomy];

  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = ["docker"];

  environment.systemPackages = [inputs.rapla.packages.${pkgs.system}.default];

  networking.domain = "trench.world";
}
