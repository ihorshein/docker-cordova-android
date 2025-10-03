# Cordova Android Docker Builder

This repository contains a `Dockerfile` to create a Docker image that includes all the necessary tools for building Android applications based on Apache Cordova.

The image is designed to provide a consistent and reproducible build environment that can be used for both local development and in Continuous Integration/Continuous Deployment (CI/CD) systems.

## Included Tools

The image is based on **Ubuntu 22.04** and includes:

*   **Java Development Kit (JDK)**: OpenJDK 17
*   **Node.js**: 20.x
*   **Gradle**: 8.13
*   **Android SDK Tools**:
    *   Command Line Tools
    *   Platform Tools
    *   SDK Platforms: 34, 35, 36
    *   SDK Build Tools: 34.0.0, 35.0.0, 36.0.0
*   **Cordova CLI**

## How to Use

### 1. Build the Docker Image

The build scripts are located in the `scripts` directory.

#### Method A: Using Scripts

##### For Windows

Run the `scripts\windows\image-build.bat` file. It will automatically execute the build command and tag the image as `cordova-android:latest`.

##### For Linux and macOS

First, make the script executable:
```shell
chmod +x scripts/unix/image-build.sh
```
Then, run it:
```shell
./scripts/unix/image-build.sh
```

#### Method B: Manual Build

Open a terminal in the root directory of this repository and run the command:

```shell
docker build -t cordova-android:latest .
```

### 2. Run the Container to Build Your Project

To conveniently run the container, you can use the `builder-shell.bat` or `builder-shell.sh` scripts.

1.  Copy the appropriate script from the `scripts` directory to the root of your **Cordova project**:
    *   For Windows: `scripts\windows\builder-shell.bat`
    *   For Linux/macOS: `scripts\unix\builder-shell.sh`
2.  Run the script from a terminal inside your project's directory.

#### For Windows

```shell
.\builder-shell.bat
```

#### For Linux and macOS

First, make the script executable:
```shell
chmod +x builder-shell.sh
```
Then, run it:
```shell
./builder-shell.sh
```

After running the script, you will be in an interactive shell inside the container, where your project is available in the `/app` directory.

### 3. Build the Application

Once inside the container's shell, you can run standard Cordova commands:

```bash
# Add the Android platform to your project
cordova platform add android

# Check for build requirements
cordova requirements android

# Build the Android app
cordova build android

# Exit the container
exit
```

The built APK will be available in your project's `platforms/android/app/build/outputs/apk/` directory on your host machine.

## Troubleshooting

### Build Error: `kotlin-stdlib-jdk*` vs `kotlin-stdlib`

Newer versions of [`cordova-android`](https://cordova.apache.org/announcements/2025/03/26/cordova-android-14.0.0.html) may produce a build error related to duplicate Kotlin standard libraries. This is because `kotlin-stdlib-jdk7` and `kotlin-stdlib-jdk8` have been merged into a single `kotlin-stdlib` library.

**Solution: Set Kotlin Version in `config.xml`**

Add the following preference to your project's `config.xml` file inside the `<platform name="android">` tag. This forces Cordova to use a specific version of the Kotlin Gradle plugin, which in turn uses the correct `kotlin-stdlib`.

```xml
<platform name="android">
    <preference name="GradlePluginKotlinVersion" value="1.9.24" />
    ...
</platform>
```

## Customization

You can easily change the versions of the installed tools by modifying the `ENV` variables at the top of the `Dockerfile`.

```dockerfile
ENV NODE_VERSION=20
ENV JAVA_VERSION=17
ENV GRADLE_VERSION=8.13
ENV ANDROID_CMD_TOOLS_VERSION=13114758
ENV ANDROID_PACKAGES="..."
```

After changing these values, you will need to rebuild the Docker image.

## Useful Links

*   [Cordova CLI Reference](https://cordova.apache.org/docs/en/12.x-2025.01/reference/cordova-cli/index.html)
*   [Android Platform Guide](https://cordova.apache.org/docs/en/12.x-2025.01/guide/platforms/android/index.html)
*   Latest Cordova Android Releases:
    *   [cordova-android 14.0.1](https://cordova.apache.org/announcements/2025/04/30/cordova-android-14.0.1.html)
    *   [cordova-android 14.0.0](https://cordova.apache.org/announcements/2025/03/26/cordova-android-14.0.0.html)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
