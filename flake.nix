{
  description = "Flake templates for programming languages along with devshells";
  outputs = { self }: {
    templates = {
      #  nix flake new -t git+https://csgitlab.reading.ac.uk/philipwilk/templates?ref=main#java javaProj
      java ={
        path = ./java;
        description= "Java package with devshell template";
      };
      #  nix flake new -t git+https://csgitlab.reading.ac.uk/philipwilk/templates?ref=main#cpp cppProj
      cpp = {
        path = ./cpp;
        description = "C++ package with devshell template";
      };
    };

    defaultTemplate = self.templates.java;
  };
}
