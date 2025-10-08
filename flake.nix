{
  description = "Rust environment";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        rustToolchain = pkgs.rust-bin.stable."1.89.0".default.override {
          extensions = [ "rust-src" "clippy" "rustfmt" ];
        };
      in {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            rustToolchain
            gcc
            arduino-cli
          ];

          buildInputs = with pkgs; [
            openssl
            glib.dev
            pkg-config
            gcc
            libGL
            rocmPackages.clang
            libxkbcommon
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
            rust-analyzer
            triton-llvm
            opencv
          ];

          shellHook = ''
            mkdir -p ~/.rust-rover/toolchain

            ln -sfn ${rustToolchain}/lib ~/.rust-rover/toolchain
            ln -sfn ${rustToolchain}/bin ~/.rust-rover/toolchain

            export RUST_SRC_PATH="$HOME/.cargo/bin/rust-src/library"
            echo "RUST_SRC_PATH set to $RUST_SRC_PATH"
          '';
        };
      }
    );
}
# car 8:
# TOKEN= 746007
# CAR_IP = 192.168.0.105
# CAMERA_IP =  
