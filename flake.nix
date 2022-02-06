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

        makeRustInfo =
          { version
          , profile
          }:
          let
            rust = (pkgs.rust-bin.${version}.latest.${profile}.override { extensions = [ "rust-src" ]; });
            path = pkgs.rust.packages.${version}.rustPlatform.rustLibSrc;
          in
          {
            name = "rust-" + version + "-" + profile;

            path = path;

            drvs = [
              pkgs.openssl
              pkgs.pkgconfig
              rust
            ];
          };

        makeRustEnv =
          { version
          , profile
          }:
          let
            rustInfo = makeRustInfo {
              inherit version profile;
            };
          in
          pkgs.buildEnv {
            name = rustInfo.name;
            paths = rustInfo.drvs;
          };

        matrix = {
          stable-default = {
            version = "stable";
            profile = "default";
          };

          stable-minimal = {
            version = "stable";
            profile = "minimal";
          };

          beta-default = {
            version = "beta";
            profile = "default";
          };

          beta-minimal = {
            version = "beta";
            profile = "minimal";
          };
        };
      in
      {
        devShell =
          let
            version = matrix.stable-default.version;
            profile = matrix.stable-default.profile;
            rustInfo = makeRustInfo {
              inherit version profile;
            };
          in
          pkgs.mkShellNoCC {
            name = rustInfo.name;

            RUST_SRC_PATH = rustInfo.path;

            buildInputs = rustInfo.drvs;
          };

        devShells = builtins.mapAttrs
          (
            name: value:
              let
                version = value.version;
                profile = value.profile;
                rustInfo = makeRustInfo {
                  inherit version profile;
                };
              in
              pkgs.mkShellNoCC {
                name = rustInfo.name;

                RUST_SRC_PATH = rustInfo.path;

                buildInputs = rustInfo.drvs;
              }
          )
          matrix;

        packages = builtins.mapAttrs
          (name: value: makeRustEnv {
            version = value.version;
            profile = value.profile;
          })
          matrix;

        defaultPackage = matrix.stable-default;
      }
    );
}
