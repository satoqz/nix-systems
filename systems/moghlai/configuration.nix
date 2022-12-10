{
  modules,
  user,
  ...
}: {
  imports = with modules; [
    ssh-server
    # self-management
    selfhosted-services
  ];

  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = ["docker"];

  networking.domain = "trench.world";
}
