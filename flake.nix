{
  description = "Rust shells";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShells = {
          default = import ./resources/dev/common.nix {
            inherit pkgs;
            version = "stable";
            profile = "default";
          };

          stable.default = import ./resources/dev/common.nix {
            inherit pkgs;
            version = "stable";
            profile = "default";
          };

          stable.minimal = import ./resources/dev/common.nix {
            inherit pkgs;
            version = "stable";
            profile = "minimal";
          };

          beta.default = import ./resources/dev/common.nix {
            inherit pkgs;
            version = "beta";
            profile = "default";
          };

          beta.minimal = import ./resources/dev/common.nix {
            inherit pkgs;
            version = "beta";
            profile = "minimal";
          };
        };
      }
    );
}
