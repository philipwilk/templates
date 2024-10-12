plugins {
  application
  id("org.gradlex.reproducible-builds") version "1.0"
}

application {
  mainClass = "javaProj.Main"
}

tasks.compileJava {
    options.release = 22
}

configurations.all {
  resolutionStrategy {
      failOnNonReproducibleResolution()
  }
}

