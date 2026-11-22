plugins {
    id("com.android.application")
}

android {
    namespace = "com.yuzhe.converter"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.yuzhe.converter"
        minSdk = 24
        targetSdk = 34
        versionCode = 13
        versionName = "1.2.1"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isDebuggable = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    buildFeatures {
        buildConfig = false
    }
}
