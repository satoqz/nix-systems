{ inputs, user, hostname, home, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs user hostname; };
    users.${user} = {
      home.stateVersion = "23.05";
      imports = home;
    };
  };
}
