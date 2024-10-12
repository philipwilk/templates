{
  description = "Java dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    build-gradle-application.url = "github:raphiz/buildGradleApplication";
    gradle2nix.url = "github:tadfisher/gradle2nix";
  };

  outputs = { self, nixpkgs, flake-utils, build-gradle-application, ... }:
    let
      pname = "javaproj";
      version = "0.0.1";
      sys = "x86_64-linux";
      org = "your.org.com";
      # java --enable-preview --source 22 main.java
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let 
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ build-gradle-application.overlays.default ];
        };
        stdenv = pkgs.stdenv;
        lib = pkgs.lib;
        jdk = pkgs.jdk22;
        buildGradleApplication = pkgs.buildGradleApplication;
        nativeBuildInputs = with pkgs; [
          jdk
          gradle_8
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            jdt-language-server
            java-language-server
            gradle-completion
            updateVerificationMetadata
          ] ++ nativeBuildInputs;
        };
        # Mostly copied from https://nixos.org/manual/nixpkgs/stable/#sec-language-java
        packages = {
            default = self.packages.${sys}.${pname};
            ${pname} = buildGradleApplication {
              inherit pname;
              inherit version;
              src = ./.;
              inherit nativeBuildInputs;
              meta.license = lib.licenses.mit;
        };
      };
    }
  );
}
