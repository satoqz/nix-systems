{
  inputs.systems.url = "github:satoqz/nix-systems";

  outputs = {systems, ...}: {
    homeConfigurations."satoqz@ubuntu" = systems.lib.homeManagerConfiguration {
      system = "aarch64-linux";
      user = "satoqz";
    };

    devShells = systems.lib.forAllPkgs (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          home-manager
          gnumake
        ];
      };
    });

    formatter = systems.lib.forAllPkgs (pkgs: pkgs.alejandra);
  };
}
