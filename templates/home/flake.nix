{
  inputs.configs.url = "github:satoqz/configs";

  outputs = {configs, ...}:
    configs.lib.homeFlake {
      pkgs = import configs.inputs.nixpkgs {
        system = "aarch64-linux";
        modules = with configs.homeModules; [zsh];
      };
    };
}
