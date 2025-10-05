{
  description = "Haskell package with devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
            pname = "haskell-app";
            haskellPackages = pkgs.haskell.packages.ghc912.override {
              # overrides = self: super: {
              # cabal = super.Cabal_3_14_2_0;
              # };
            };
            overlay = final: prev: {
              ${pname} = final.callCabal2nix pname ./. { };
            };
            haskellPackagesWithApp = haskellPackages.extend overlay;
          in
          {
            # Apply nixpkgs overlays here
            # _module.args.pkgs = import inputs.nixpkgs {
            #   inherit system;
            #   overlays = final: prev: [
            #     # inputs.flake.overlay here
            #   ];
            # };
            devShells.default = haskellPackagesWithApp.shellFor {
              packages = p: [
                p.${pname}
              ];
              nativeBuildInputs = with haskellPackagesWithApp; [
                cabal-install
                haskell-language-server
              ];
            };
            packages = {
              default = self'.packages.${pname};
              ${pname} = haskellPackagesWithApp.${pname};
            };
          };
      }
    );
}
