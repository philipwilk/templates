{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
  let
    pname = "cppProj";
    version = "0.0.1";
    sys = "x86_64-linux";
  in
  flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      stdenv = pkgs.stdenv;
      lib = pkgs.lib;
      nativeBuildInputs = with pkgs; [
        gnumake
        sccache
        gcc.cc.libgcc
        makeWrapper
      ];
    in {
      devShells.default  =pkgs.mkShell {
        buildInputs = with pkgs; [
          gdb
          valgrind
          tree-sitter-grammars.tree-sitter-c
          tree-sitter-grammars.tree-sitter-cmake
          tree-sitter-grammars.tree-sitter-cpp
          clang-tools
        ] ++ nativeBuildInputs;
      };

      packages = {
        default = self.packages.${sys}.${pname};
        ${pname} = stdenv.mkDerivation {
          inherit pname;
          inherit version;
          src = ./.;
          inherit nativeBuildInputs;
          meta.license = lib.licenses.mit;

          preBuildPhase = ''
            mkdir ./build
          '';

          makeFlags = [
            "CC=g++"
          ];

          installPhase = ''
            mkdir -p $out/bin
            cp build/main $out/bin/${pname}
          '';
        };
      };
    }
  );
}
