{
  self,
  nixpkgs,
  vscode-server,
  ...
}: let
  modules = self.nixosModules;
  hosts = self.lib.importModules ./hosts;

  toSystem = hostName: configuration:
    self.lib.nixosSystem (configuration
      // {
        inherit hostName;
      });

  mkConfigurations = builtins.mapAttrs toSystem;
in
  mkConfigurations {
    vps.modules = [
      hosts.vps
      modules.satoqz
      modules.caretaker
      modules.selfhosted
    ];

    utm-vm.arch = "aarch64";
    utm-vm.modules = [
      hosts.utm-vm
      modules.satoqz
      vscode-server.nixosModules.default
    ];

    ci.modules = [
      hosts.ci
    ];
  }
