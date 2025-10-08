{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, crane, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        
        opencvGtk = pkgs.opencv.override (old : { enableGtk2 = true; });

        runtimeDeps= with pkgs; [
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
            opencvGtk
            gtk2-x11
        ];

        libPath = lib.makeLibraryPath runtimeDeps ;
        

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        inherit (pkgs) lib;

        # src = ./.;

        rustToolchain = pkgs.rust-bin.stable.latest.default;

        # craneLib = (crane.mkLib pkgs).overrideScope (final: prev: {
        #   rustc = rustToolchain;
        #   cargo = rustToolchain;
        #   rustfmt = rustToolchain;
        # });

        # cargoArtifacts = craneLib.buildDepsOnly {
        #   inherit src;
        # };


       in {

        devShell = pkgs.mkShell {


          buildInputs = with pkgs; [ ] ++ runtimeDeps;

          nativeBuildInputs = with pkgs; [
            rustToolchain
          ];

          LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
          LD_LIBRARY_PATH = libPath;
        };
      });
}

