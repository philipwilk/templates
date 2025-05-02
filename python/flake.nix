{
  description = "Python package+devshell example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
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
        projectPython = pkgs.python313;
        pyPackages = pkgs.python313Packages;
        lib = pkgs.lib;
        dependencies = with pyPackages; [
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (projectPython.withPackages (
              packages:
              with packages;
              [
                python-lsp-server
                python-lsp-ruff
                pytest
              ]
              ++ dependencies
            ))
            ruff
          ];
          # declare your env vars here
          # export x=y
          shellHook = "";
        };

        packages = {
          default = self.packages.${sys}.${pyproject.project.name};
          ${pyproject.project.name} = pyPackages.buildPythonApplication {
            pname = pyproject.project.name;
            inherit (pyproject.project) version;

            pyproject = true;
            build-system = with pyPackages; [
              setuptools
            ];
            # remove once tests have been added
            doCheck = false;
            src = ./.;

            inherit dependencies;
            nativeCheckInputs = [
              pyPackages.pytestCheckHook
            ];

            meta = {
              license = lib.licenses.mit;
            };
          };
        };
      }
    );
}
