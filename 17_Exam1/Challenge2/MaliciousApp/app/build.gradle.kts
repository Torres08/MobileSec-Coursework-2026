plugins {
    alias(libs.plugins.android.application)
}

android {
    signingConfigs {
        getByName("debug") {
            storeFile =
                file("/home/torres/Documents/Github/MAS/MobileSec-Coursework-2026/17_Exam1/Challenge2/MaliciousApp/app/mykey.jks")
            storePassword = "mobisec"
            keyAlias = "key0"
            keyPassword = "mobisec"
        }
    }
    namespace = "com.example.maliciousapp"
    compileSdk {
        version = release(36)
    }



    defaultConfig {
        applicationId = "com.example.maliciousapp"
        minSdk = 24
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

dependencies {
    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.activity)
    implementation(libs.constraintlayout)
    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)
}