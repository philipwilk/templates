
{
  description = "Python package+devshell example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
  let
    sys = "x86_64-linux";
  in
  flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      pyproject = pkgs.lib.importTOML ./pyproject.toml;
      pyPackages = pkgs.python313Packages;
      stdenv = pkgs.stdenv;
      lib = pkgs.lib;
      nativeBuildInputs = with pyPackages; [
        pkgs.python313
        setuptools
      ];
      buildInputs = with pkgs; [];
    in {
      devShells.default  = (pkgs.python313.buildEnv.override {
        extraLibs = with pyPackages; [
          python-lsp-server
        ];
      }).env;

      packages = {
        default = self.packages.${sys}.${pyproject.project.name};
        ${pyproject.project.name} = pyPackages.buildPythonApplication {
          inherit nativeBuildInputs buildInputs;
          pname = pyproject.project.name;
          inherit (pyproject.project) version;

          pyproject = true;
          build-system = with pyPackages; [
            setuptools
          ];
          doCheck = false;
          src = ./.;

          dependencies = with pyPackages; [
          ];

          meta = {
            license = lib.licenses.mit;
          };
        };
      };
    }
  );
}
