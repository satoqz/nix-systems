{
  lib,
  rustPlatform,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  name = "hash";
  version = "main";

  src = builtins.fetchGit {
    url = "git@github.com:satoqz/hash";
    rev = "ea4c8a78fd2ee40150b2e48b72755c2b3cfac3d7";
  };

  buildInputs = [darwin.apple_sdk.frameworks.AppKit];

  sourceRoot = "source/cli";

  cargoHash = "sha256-gnHe1wkxxwlW50BkHgztqiXL4JVhvM1Gxh+AyZxq8pY=";
}
