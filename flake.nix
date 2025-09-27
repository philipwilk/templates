{
  description = "Flake templates for programming languages along with devshells";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    template.url = "path:./template";
    java.url = "path:./java";
    javafx.url = "path:./javafx";
    c.url = "path:./c";
    cpp.url = "path:./cpp";
    matlab.url = "path:./matlab";
    python.url = "path:./python";
    python-flask.url = "path:./python-flask";
    rust.url = "path:./rust";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        self,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        systems = [
          "x86_64-linux"
        ];

        flake =
          { lib, ... }:
          {
            templates = {
              default = self.templates.java;

              # nix flake new -t git+https://git.fogbox.uk/templates?ref=main#template newTemplate
              template = {
                path = ./template;
                description = "Template with package and devshell template";
              };
              # nix flake new -t git+https://git.fogbox.uk/templates?ref=main#java javaProj
              java = {
                path = ./java;
                description = "Java package with devshell template";
              };
              # nix flake new -t git+https://git.fogbox.uk/templates?ref=main#javafx javaProj
              javafx = {
                path = ./javafx;
                description = "Java package with javafx with devshell template";
              };
              # nix flake new -t git+https://git.fogbox.uk/templates?ref=main#cpp cppProj
              cpp = {
                path = ./cpp;
                description = "C++ package with devshell template";
              };
              # nix flake new -t git+https://git.fogbox.uk/templates?ref=main#c cProj
              c = {
                path = ./c;
                description = "C package with devshell template";
              };
              #  nix flake new -t git+https://git.fogbox.uk/templates?ref=main#matlab matlabProj
              matlab = {
                path = ./matlab;
                description = "Matlab dev shell";
              };
              # nix flake new -t git+https://git.fogbox.uk/templates?ref=main#python pythonProj
              python = {
                path = ./python;
                description = "Python package with devshell template";
              };
              # nix flake new -t git+https://git.fogbox.uk/templates?ref=main#python-flask pythonProj
              python-flask = {
                path = ./python-flask;
                description = "Python package with flask with devshell template";
              };
              # nix flake new -t git+https://git.fogbox.uk/templates?ref=main#rust rustProj
              rust = {
                path = ./rust;
                description = "Rust package with devshell template";
              };
            };
          };

        perSystem =
          {
            config,
            lib,
            system,
            ...
          }:
          {
            checks =
              let
                realTemplates = lib.attrsets.filterAttrs (n: v: n != "default") self.templates;
                withShell = lib.attrsets.filterAttrs (
                  n: v: lib.hasAttr "default" inputs.${n}.outputs.devShells.${system}
                ) realTemplates;
                withPackage = lib.attrsets.filterAttrs (
                  n: v: lib.hasAttr "default" inputs.${n}.outputs.packages.${system}
                ) realTemplates;

                shellChecks = lib.mapAttrs' (
                  n: v: lib.nameValuePair "devshells-${n}" inputs.${n}.outputs.devShells.${system}.default

                ) withShell;

                packageChecks = lib.mapAttrs' (
                  n: v: lib.nameValuePair "packages-${n}" inputs.${n}.outputs.packages.${system}.default

                ) withPackage;
              in
              shellChecks;
          };
      }
    );
}
