# crabfish

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## To get this project to compile properly, several changes had to be made to gradle files
## in android/app/build.gradle, add/change the following lines:   
ndkVersion = "27.0.12077973"
compileSdk = 35

## in android/settings.gradle, change this line:
id "com.android.application" version "8.7.0" apply false

## in android/gradle/gradle-wrapper.properties, change this line:
distributionUrl=https\://services.gradle.org/distributions/gradle-8.10.2-all.zip


