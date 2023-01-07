{
  self,
  pkgs,
  system,
  ...
}: let
  inherit (self) outPath;
  inherit (pkgs) writeShellScriptBin;
in {
  deploy-nixos = writeShellScriptBin "deploy-nixos" ''
    set -e

    usage() {
      echo "Usage: deploy-nixos <ssh host> <configuration name> [--test]"
      exit 1
    }

    if [ -z "$1" ] || [ -z "$2" ]; then
      usage
    fi

    mode="switch"
    [ "$3" = "--test" ] && mode="test"

    nix copy --to "ssh://$1" ${outPath}
    ssh -t "$1" sudo nixos-rebuild "$mode" --flake "path:${outPath}#$2"
  '';

  home-configs = writeShellScriptBin "home-configs" ''
    set -e

    usage() {
      echo "Usage: home-configs <build|switch> <configuration name>"
      exit 1
    }

    if [ -z "$2" ]; then
      usage
    fi

    target="path:${outPath}#homeConfigurations.${system}.$2.activationPackage"

    if [ "$1" = "build" ]; then
        nix build --impure "$target"
    elif [ "$1" = "switch" ]; then
        result=$(nix build --impure --no-link --print-out-paths "$target")
        $result/activate
    else
      usage
    fi
  '';

  deploy-home = writeShellScriptBin "deploy-home" ''
    set -e

    usage() {
      echo "Usage: deploy <ssh host> <configuration name>"
      exit 1
    }

    if [ -z "$1" ] || [ -z "$2" ]; then
      usage
    fi

    nix copy --to "ssh://$1" ${outPath}
    ssh "$1" nix run path:${outPath}#home-configs switch "$2"
  '';
}
