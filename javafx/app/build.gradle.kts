plugins {
  application
  id("org.gradlex.reproducible-builds") version "1.0"
  id("org.openjfx.javafxplugin") version "0.1.0"
}

javafx {
  version = "23.0.1";
  modules("javafx.controls", "javafx.fxml")
}

application {
  mainClass = "javaProj.Main"
}

tasks.compileJava {
    options.release = 23
}

configurations.all {
  resolutionStrategy {
      failOnNonReproducibleResolution()
  }
}

