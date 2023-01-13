{
  description = "Rust shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [(import inputs.rust-overlay)];
        };

        makeRustInfo = {
          version,
          profile,
        }: let
          rust = pkgs.rust-bin.${version}.latest.${profile}.override {extensions = ["rust-src"];};
          path = pkgs.rust.packages.${version}.rustPlatform.rustLibSrc;
        in {
          name = "rust-" + version + "-" + profile;

          path = path;

          drvs = [
            pkgs.just
            pkgs.openssl
            pkgs.pkgconfig
            pkgs.rust-analyzer
            rust
          ];
        };

        makeRustEnv = {
          version,
          profile,
        }: let
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
      in {
        formatter = pkgs.alejandra;

        devShell = let
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

        devShells =
          builtins.mapAttrs
          (
            name: value: let
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

        packages =
          builtins.mapAttrs
          (name: value:
            makeRustEnv {
              version = value.version;
              profile = value.profile;
            })
          matrix;

        defaultPackage = makeRustEnv {
          version = "stable";
          profile = "default";
        };
      }
    );
}
