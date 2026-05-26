allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    project.evaluationDependsOn(":app")
}

subprojects {
    val subproject = this

    fun configureAndroid() {
        subproject.extensions.findByName("android")?.let { extension ->
            if (extension is com.android.build.gradle.BaseExtension) {
                extension.compileSdkVersion(36)
            }
        }
    }

    if (subproject.state.executed) {
        configureAndroid()
    } else {
        subproject.afterEvaluate {
            configureAndroid()
        }
    }

    // Use task-level configuration to avoid "extension finalized" errors.
    // This forces both Java and Kotlin tasks to use JVM 17.
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_17.toString()
        targetCompatibility = JavaVersion.VERSION_17.toString()
    }

    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

// Built-in Kotlin automatically sets jvmTarget based on targetCompatibility.
// The previous explicit task configuration is no longer needed.

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
