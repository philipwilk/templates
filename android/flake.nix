{
  description = "Java dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    make-shell.url = "github:nicknovitski/make-shell";
    build-gradle-application = {
      url = "github:raphiz/buildGradleApplication";
      inputs.flake-parts.follows = "flake-parts";
    };
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
            pname = "androidproject";
            version = "0-unstable";
            jdk = pkgs.jdk11;
            gradle = pkgs.callPackage pkgs.gradle-packages.gradle_8 { java = jdk; };
          in
          {
            # Apply build-gradle-application overlay
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.build-gradle-application.overlays.default
              ];
              config = {
                android_sdk.accept_license = true;
                allowUnfree = true;
              };
            };
            make-shells.default = {
              packages = with pkgs; [
                jdt-language-server
                java-language-server
                gradle-completion
                updateVerificationMetadata
                jdk
                gradle
              ];
              env = {
                # environment variables for development shell
                #ANDROID_HOME =
              };
            };
            packages = {
              default = self'.packages.${pname};
              ${pname} = pkgs.buildGradleApplication {
                inherit
                  pname
                  version
                  jdk
                  gradle
                  ;
                src = ./.;
                buildTask = "installDist";
                installLocation = "app/build/install/*/";

                meta = {
                  license = lib.licenses.mit;
                };
              };
            };
          };
      }
    );
}
