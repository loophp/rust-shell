{
  pkgs,
  version,
  profile
}:

let
  mkShellNoCC = pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; };
  rust = (pkgs.rust-bin.${version}.latest.${profile}.override { extensions = [ "rust-src" ]; });
  path = pkgs.rust.packages.${version}.rustPlatform.rustLibSrc;
in mkShellNoCC {
  name = "rust-" + version + "-" + profile;

  RUST_SRC_PATH = path;

  buildInputs = [
    pkgs.openssl
    pkgs.pkgconfig
    rust
  ];
}
