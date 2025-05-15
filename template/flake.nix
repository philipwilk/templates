{
  description = "A template for creating templates";

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
            pname = "javaproject";
            version = "0-unstable";
            # build-time dependencies here
            nativeBuildInputs = with pkgs; [
            ];
            # runtime dependencies here
            buildInputs = with pkgs; [
            ];
          in
          {
            # Apply nixpkgs overlays here
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                # inputs.flake.overlay here
              ];
            };
            make-shells.default = {
              # dev/testing dependencies here
              packages =
                with pkgs;
                [
                ]
                ++ nativeBuildInputs
                ++ buildInputs;
              env = {
                # environment variables for development shell
              };
            };
            packages = {
              default = self'.packages.${pname};
              ${pname} = pkgs.stdenv.mkDerivation {
                inherit pname version;

                src = ./.;

                inherit buildInputs nativeBuildInputs;

                meta = {
                  license = lib.licenses.mit;
                };
              };
            };
          };
      }
    );
}
