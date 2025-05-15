{
  description = "Python package+devshell example";

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
            pyProject = pkgs.lib.importTOML ./pyproject.toml;
            projectPython = pkgs.python313;
            pyPackages = pkgs.python313Packages;
            dependencies = with pyPackages; [
              # put pyproject.toml dependencies here
            ];
          in
          {
            make-shells.default = {
              packages = with pkgs; [
                (projectPython.withPackages (
                  packages:
                  with packages;
                  [
                    # put pyproject.toml test/dev dependencies here
                    python-lsp-server
                    python-lsp-ruff
                    pytest
                  ]
                  ++ dependencies
                ))
                ruff
              ];
              env = {
                # environment variables for development shell
              };
            };
            packages = {
              default = self'.packages.${pyProject.project.name};
              ${pyProject.project.name} = pyPackages.buildPythonApplication {
                pname = pyProject.project.name;
                inherit (pyProject.project) version;

                pyproject = true;
                build-system = with pyPackages; [
                  setuptools
                ];
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
          };
      }
    );
}
