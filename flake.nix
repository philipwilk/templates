{
  description = "Java dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      pname = "javaproj";
      sys = "x86_64-linux";
      # java --enable-preview --source 22 main.java
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let 
        pkgs = nixpkgs.legacyPackages.${system};
        stdenv = pkgs.stdenv;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            jdk22
            jdt-language-server
          ];
        };
        #packages.${sys}.${pname} = stdenv.mkDerivation {
        #  inherit pname;
        #};
        #packages.${sys}.default = self.packages.${sys}.${pname};
      }
    );
}
