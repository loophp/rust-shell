{
  pkgs,
  version,
  profile
}:

let
  mkShellNoCC = pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; };
  rust = (pkgs.rust-bin.${version}.latest.${profile}.override { extensions = [ "rust-src" ]; });
in mkShellNoCC {
  name = "rust-" + version + "-" + profile;

  buildInputs = [
    pkgs.openssl
    pkgs.pkgconfig
    rust
  ];
}
