{
  description = "Java dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
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
        pkgs = nixpkgs.legacyPackages.${system};
        stdenv = pkgs.stdenv;
        lib = pkgs.lib;
        jdk = pkgs.jdk22;
        nativeBuildInputs = with pkgs; [
          jdk
          ant
          makeWrapper
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            jdt-language-server
            java-language-server
          ] ++ nativeBuildInputs;
        };
        # Mostly copied from https://nixos.org/manual/nixpkgs/stable/#sec-language-java
        packages = {
            default = self.packages.${sys}.${pname};
            ${pname} = stdenv.mkDerivation {
              inherit pname;
              inherit version;
              src = ./.;
              inherit nativeBuildInputs;
            
              buildPhase = ''
                ant # build the project using ant
              '';

              installPhase = ''
                # copy generated jar file(s) to an appropriate location in $out
                mkdir -p $out/bin $out/share/${pname}
                install -Dm644 target/${pname}.jar $out/share/${pname}

                 makeWrapper ${jdk}/bin/java $out/bin/${pname}  \
                  --add-flags "-jar $out/share/${pname}/${pname}.jar"
              '';
        };
      };
    }
  );
}
