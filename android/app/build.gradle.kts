import java.util.Base64

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val dartDefines: Map<String, String> = run {
    val encoded = project.findProperty("dart-defines") as String? ?: ""
    if (encoded.isEmpty()) emptyMap()
    else encoded.split(",").associate { entry ->
        val decoded = String(Base64.getDecoder().decode(entry))
        val parts = decoded.split("=", limit = 2)
        parts[0] to (parts.getOrElse(1) { "" })
    }
}

val appName = dartDefines["APP_NAME"] ?: "Reminders"
val appId   = dartDefines["APP_ID"]   ?: "com.daily.reminders"

android {
    namespace = "com.daily.reminders"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = appId
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "app_name", appName)
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}