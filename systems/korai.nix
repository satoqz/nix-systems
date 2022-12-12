{
  pkgs,
  user,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home-manager.users.${user} = {
    programs = {
      alacritty.enable = true;
      firefox.enable = true;
      vscode.enable = true;
      sioyek.enable = true;
    };

    home.packages = with pkgs; [
      discord
      slack
      teams
      rectangle
    ];
  };
}
