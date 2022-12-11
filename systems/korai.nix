{
  pkgs,
  user,
  ...
}: {
  home-manager.users.${user} = {
    programs = {
      firefox.enable = true;
      vscode.enable = true;
      sioyek.enable = true;
    };

    home.packages = with pkgs; [
      discord
      slack
      teams
      iterm2
      utm
      rectangle
    ];
  };
}
