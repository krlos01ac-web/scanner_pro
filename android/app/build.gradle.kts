plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.araujo.scanner_plus"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // Correção do erro de jvmTarget
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.araujo.scanner_plus"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

   buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")

            // ✅ MUDANÇA: Coloque FALSE para desligar o otimizador chato
            isMinifyEnabled = false
            isShrinkResources = false
            
            // Pode deixar essa linha ou apagar, tanto faz agora
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}