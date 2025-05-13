{
  description = "Flake templates for programming languages along with devshells";
  outputs =
    { self }:
    {
      templates = {
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
      };

      defaultTemplate = self.templates.java;
    };
}
