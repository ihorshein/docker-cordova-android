# Use Ubuntu as the base image
FROM ubuntu:22.04

# Set environment variables for non-interactive package installation
ENV DEBIAN_FRONTEND=noninteractive

# Define versions for tools to be installed
ENV NODE_VERSION=20
ENV JAVA_VERSION=17
ENV GRADLE_VERSION=8.13
ENV ANDROID_CMD_TOOLS_VERSION=13114758
ENV ANDROID_PACKAGES="platforms;android-34 platforms;android-35 platforms;android-36 build-tools;34.0.0 build-tools;35.0.0 build-tools;36.0.0"

# Set environment variables for build tools
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV GRADLE_HOME=/opt/gradle
ENV PATH=$PATH:$GRADLE_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# 1. Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    unzip \
    git \
    curl \
    ca-certificates \
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install OpenJDK
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-${JAVA_VERSION}-jdk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs

# 3. Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    # Create a symlink for convenience
    ln -s /opt/gradle/gradle-${GRADLE_VERSION}/* /opt/gradle/ && \
    rm /tmp/gradle-${GRADLE_VERSION}-bin.zip

# 4. Install Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMD_TOOLS_VERSION}_latest.zip -P /tmp && \
    unzip /tmp/commandlinetools-linux-${ANDROID_CMD_TOOLS_VERSION}_latest.zip -d ${ANDROID_HOME}/cmdline-tools && \
    # Rename to match SDK structure
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/commandlinetools-linux-${ANDROID_CMD_TOOLS_VERSION}_latest.zip

# Accept licenses and install required SDK packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" ${ANDROID_PACKAGES} && \
    # Clean up sdkmanager cache
    rm -rf /root/.android/cache/* /root/.android/repositories.cfg

# Install Cordova CLI globally
RUN npm install -g cordova

# Create a non-root user for building
RUN useradd -ms /bin/bash builder && \
    usermod -aG sudo builder && \
    echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Grant ownership of directories to the new user
RUN mkdir -p /app && chown -R builder:builder /app ${ANDROID_HOME}

# Switch to the builder user
USER builder

# Set the working directory
WORKDIR /app

# Default command
CMD ["bash"]
