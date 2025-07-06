import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
  id("com.android.application") version "7.4.1" apply false
  id("org.gradlex.reproducible-builds") version "1.0"
}

dependencies {
    implementation("com.android.library:com.android.library.gradle.plugin:8.11.0")
    implementation("androidx.appcompat:appcompat:1.7.1")
    implementation("androidx.compose.material3:material3:1.3.2")
    implementation("androidx.test.ext:junit:1.2.1")
    implementation("androidx.test.espresso:espresso-core:3.6.1")
}

android {
  namespace = "uk.name.app"
  compileSdk = 36

  defaultConfig {
        applicationId = "uk.fogbox.tiles"
        minSdk = 34
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}

configurations.all {
  resolutionStrategy {
      failOnNonReproducibleResolution()
  }
}

