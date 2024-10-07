{
  description = "Flake templates for programming languages along with devshells";
  outputs = { self }: {
    templates = {
      java ={
        path = ./java;
        description= "Java package with devshell template";
      };
    };

    defaultTemplate = self.templates.java;
  };
}
