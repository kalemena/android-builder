FROM ubuntu:18.04

MAINTAINER Kalemena

# SDK version
ENV ANDROID_SDK_VERSION 4333796
ENV PLATFORM_VERSION 28
ENV BUILD_TOOLS_VERSION 28.0.3

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Kalemena Docker Android Builder" \
      org.label-schema.description="Kalemena Docker Android Builder" \
      org.label-schema.url="private" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/kalemena/docker-android-builder" \
      org.label-schema.vendor="Kalemena" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive

# Update apt-get
RUN apt-get -qq update && \
  apt-get -qq install -y --no-install-recommends \
    zip unzip \
    wget \
    xxd \
    software-properties-common && \
  apt-add-repository ppa:openjdk-r/ppa && \
  apt-get -qq update && \
  apt-get -qq install -y openjdk-8-jdk && \
  apt-get -qq autoremove -y && \
  apt-get -qq clean && \
  rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Install Android SDK (https://developer.android.com/studio#downloads)
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_VERSION.zip -q && \
  mkdir /usr/local/android && \
  unzip -q sdk-tools-linux-$ANDROID_SDK_VERSION.zip -d /usr/local/android && \
  rm sdk-tools-linux-$ANDROID_SDK_VERSION.zip

# Environment variables
ENV ANDROID_HOME /usr/local/android
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV ANDROID_NDK_HOME $ANDROID_HOME/ndk-bundle
ENV PATH $ANDROID_HOME/tools/bin:$ANDROID_HOME/build-tools/$BUILD_TOOLS_VERSION:$PATH

# Install Android SDK components
RUN yes | sdkmanager --licenses

WORKDIR "/src"

RUN echo "sdk.dir=$ANDROID_HOME" > local.properties

# CMD ["./gradlew", "build"]
CMD [ "/bin/bash" ]