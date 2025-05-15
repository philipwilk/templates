{
  description = "C package+devshell example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    make-shell.url = "github:nicknovitski/make-shell";
  };

  outputs =
    { self, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        nixpkgs,
        withSystem,
        ...
      }:
      {
        imports = [
          inputs.make-shell.flakeModules.default
        ];

        systems = [
          "x86_64-linux"
        ];

        perSystem =
          {
            config,
            pkgs,
            lib,
            system,
            self',
            ...
          }:
          let
            pname = "cProject";
            nativeBuildInputs = with pkgs; [
              # put build dependencies here
              gnumake
              sccache
              gcc.cc.libgcc
              makeWrapper
            ];
            buildInputs = with pkgs; [
              # put runtime dependencies here
            ];
          in
          {
            make-shells.default = {
              packages =
                with pkgs;
                [
                  gdb
                  valgrind
                  tree-sitter-grammars.tree-sitter-c
                  tree-sitter-grammars.tree-sitter-cmake
                  clang-tools
                ]
                ++ nativeBuildInputs;
              env = {
                # environment variables for development shell
              };
            };
            packages = {
              default = self'.packages.${pname};
              ${pname} = pkgs.stdenv.mkDerivation {
                inherit pname;
                version = "0-unstable";
                src = ./.;

                inherit nativeBuildInputs buildInputs;

                preBuildPhase = ''
                  mkdir ./build
                '';

                makeFlags = [
                  "CC=gcc"
                ];

                installPhase = ''
                  mkdir -p $out/bin
                  cp build/main $out/bin/${pname}
                '';

                meta = {
                  license = lib.licenses.mit;
                };
              };
            };
          };
      }
    );
}
