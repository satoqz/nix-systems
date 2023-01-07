{
  inputs.configs.url = "github:satoqz/configs";

  outputs = {configs, ...}:
    configs.lib.nixosFlake {
      hostname = "nixos";
      arch = "x86_64";
      modules = with configs.nixosModules; [satoqz];
    };
}
