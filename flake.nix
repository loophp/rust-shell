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

        makeRustEnv =
          { version
          , profile
          }:
          let
            rust = pkgs.rust-bin.${version}.latest.${profile}.override { extensions = [ "rust-src" ]; };
            path = pkgs.rust.packages.${version}.rustPlatform.rustLibSrc;
          in
          pkgs.buildEnv {
            name = "rust-" + version + "-" + profile;

            paths = [
              pkgs.openssl
              pkgs.pkgconfig
              rust
            ];
          };

        environments = {
          default = {
            version = "stable";
            profile = "default";
          };

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
            version = environments.default.version;
            profile = environments.default.profile;
            rust = (pkgs.rust-bin.${version}.latest.${profile}.override { extensions = [ "rust-src" ]; });
            path = pkgs.rust.packages.${version}.rustPlatform.rustLibSrc;
          in
          pkgs.mkShellNoCC {
            name = "rust-" + version + "-" + profile;

            RUST_SRC_PATH = path;

            buildInputs = [
              pkgs.openssl
              pkgs.pkgconfig
              rust
            ];
          };

        devShells = builtins.mapAttrs
          (
            name: value:
              let
                version = value.version;
                profile = value.profile;
                rust = (pkgs.rust-bin.${version}.latest.${profile}.override { extensions = [ "rust-src" ]; });
                path = pkgs.rust.packages.${version}.rustPlatform.rustLibSrc;
              in
              pkgs.mkShellNoCC {
                name = "rust-" + version + "-" + profile;

                RUST_SRC_PATH = path;

                buildInputs = [
                  pkgs.openssl
                  pkgs.pkgconfig
                  rust
                ];
              }
          )
          environments;

        packages = builtins.mapAttrs
          (name: value: makeRustEnv {
            version = value.version;
            profile = value.profile;
          })
          environments;

        defaultPackage = environments.default;
      }
    );
}
