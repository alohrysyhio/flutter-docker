FROM ubuntu:latest

# Set up new user and some packages
RUN apt update && apt install -y sudo
RUN apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-11-jdk-headless default-jre wget usbutils udev
RUN useradd -ms /bin/bash flutterdev
RUN usermod -aG sudo flutterdev
RUN echo 'flutterdev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER flutterdev
ENV HOME=/home/flutterdev
WORKDIR $HOME

# Prerequisites
RUN echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee7", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android.rules > /dev/null \
    && sudo service udev restart

# Prepare Android directories and system variables
RUN mkdir -p Android/Sdk/cmdline-tools
RUN mkdir -p .android && touch .android/repositories.cfg
ENV ANDROID_HOME=$HOME/Android/Sdk
ENV ANDROID_SDK_ROOT="${ANDROID_HOME}"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest"
ENV PATH="$PATH:$ANDROID_HOME/platform-tools"

#Get Android Shit
ENV ANDROID_CMDLINE_VERSION=9477386
RUN wget -O cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_VERSION}_latest.zip \
    && unzip cmdline-tools.zip \
    && rm cmdline-tools.zip \
    && mv cmdline-tools/ latest/ \
    && mv latest/ Android/Sdk/cmdline-tools/
RUN yes | sdkmanager --licenses \
    && sdkmanager "build-tools;34.0.0" "patcher;v4" "platform-tools" "platforms;android-34"

# Download Flutter SDK and set it up
RUN git clone -b stable https://github.com/flutter/flutter.git
ENV FLUTTER_HOME=$HOME/flutter
ENV PATH="$PATH:$FLUTTER_HOME/bin"
RUN flutter config --no-enable-linux-desktop \
    && flutter config --no-enable-web \
    && flutter config --no-enable-macos-desktop \
    && flutter config --no-enable-windows-desktop \
    && flutter config --no-enable-ios
RUN flutter doctor