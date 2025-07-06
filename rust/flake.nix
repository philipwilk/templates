{
  description = "Rust package+devshell example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    make-shell.url = "github:nicknovitski/make-shell";
    naersk.url = "github:nix-community/naersk";
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
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
            pname = "rustProject";
            nativeBuildInputs = with pkgs; [
              # put build dependencies here
              pkg-config
            ];
            buildInputs = with pkgs; [
              # put runtime dependencies here
              # probably
              # openssl
            ];
            naersk' = pkgs.callPackage inputs.naersk { };
          in
          {
            # apply fenix rust nightly overlay
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.fenix.overlays.default
              ];
            };
            make-shells.default = {
              packages =
                with pkgs;
                [
                  alejandra
                  rust-analyzer
                  (pkgs.fenix.stable.withComponents [
                    "cargo"
                    "clippy"
                    "rust-src"
                    "rustc"
                    "rustfmt"
                  ])
                ]
                ++ nativeBuildInputs
                ++ buildInputs;
              env = {
                # environment variables for development shell
                RUSTC_WRAPPER = lib.getExe pkgs.sccache;
              };
            };
            packages = {
              default = self'.packages.${pname};
              ${pname} = naersk'.buildPackage {
                inherit pname;
                version = "0-unstable";
                src = ./.;

                inherit nativeBuildInputs buildInputs;

                meta = {
                  license = lib.licenses.mit;
                };
              };
            };
          };
      }
    );
}
