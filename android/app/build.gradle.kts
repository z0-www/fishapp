import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val signingFile = rootProject.file("key.properties")
val releaseSigning = if (signingFile.isFile) {
    Properties().apply { signingFile.inputStream().use { load(it) } }
} else null

// Flutter passes the same encoded dart-defines to Gradle and the Dart compiler.
// A validation APK must have a separate ID so it can neither replace the
// public app on a device nor pass the public APK package check.
val dartDefines = providers.gradleProperty("dart-defines").orNull.orEmpty()
    .split(',')
    .mapNotNull { definition ->
        runCatching {
            String(Base64.getDecoder().decode(definition), Charsets.UTF_8)
        }.getOrNull()
    }
val byokValidation = "FISH_ANDROID_RELEASE_BYOK_VALIDATION=true" in dartDefines
val releaseByok = "FISH_ANDROID_RELEASE_BYOK=true" in dartDefines
require(!byokValidation || !releaseByok) {
    "Select either Android Release BYOK or the separate validation package."
}

android {
    if (releaseSigning != null) {
        signingConfigs.create("release") {
            fun property(name: String): String =
                requireNotNull(releaseSigning.getProperty(name)?.takeIf { it.isNotBlank() }) {
                    "Release signing configuration is incomplete."
                }
            val keystore = rootProject.file(property("storeFile"))
            require(keystore.isFile) { "The release keystore file does not exist." }
            val alias = property("keyAlias")
            require(!alias.equals("androiddebugkey", ignoreCase = true)) {
                "The Android debug signing identity cannot be used for release."
            }
            storeFile = keystore
            storePassword = property("storePassword")
            keyAlias = alias
            keyPassword = property("keyPassword")
        }
    }
    namespace = "com.yuzhe.fishtextadventure"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.yuzhe.fishtextadventure"
        manifestPlaceholders["fishAppLabel"] = "鱼者文游"
        manifestPlaceholders["fishReleaseByok"] = "false"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            isDebuggable = false
            if (byokValidation) {
                applicationIdSuffix = ".byokvalidation"
                manifestPlaceholders["fishAppLabel"] = "鱼者文游 · 接入验收"
                signingConfig = signingConfigs.getByName("debug")
            } else {
                manifestPlaceholders["fishReleaseByok"] = releaseByok.toString()
                signingConfig = signingConfigs.findByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
