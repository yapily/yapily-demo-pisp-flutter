## 0.2.5+1

* Bump Android dependencies to latest.

## 0.2.5

* Bump Android and Firebase dependency versions.

## 0.2.4

* Updated Gradle tooling to match Android Studio 3.1.2.

## 0.2.3

* Updated Google Play Services dependencies to version 15.0.0.

## 0.2.2

* Simplified podspec for Cocoapods 1.5.0, avoiding link issues in app archives.

## 0.2.1

* Fix setting project ID on Android.

## 0.2.0

* **Breaking change**. Options API is now async to interoperate with native code that configures Firebase apps.
* Provide a getter for the default app
* Fix setting of GCM sender ID on iOS

## 0.1.2

* Fix projectID on iOS

## 0.1.1

* Fix behavior of constructor for named Firebase apps.

## 0.1.0

* **Breaking change**. Set SDK constraints to match the Flutter beta release.

## 0.0.7

* Fixed Dart 2 type errors.

## 0.0.6

* Enabled use in Swift projects.

## 0.0.5

* Moved to the io.flutter.plugins org.

## 0.0.4

* Fixed warnings from the Dart 2.0 analyzer.
* Simplified and upgraded Android project template to Android SDK 27.
* Updated package description.

# 0.0.3

* **Breaking change**. Upgraded to Gradle 4.1 and Android Studio Gradle plugin
  3.0.1. Older Flutter projects need to upgrade their Gradle setup as well in
  order to use this version of the plugin. Instructions can be found
  [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).

## 0.0.2

* Fixes for database URL on Android
* Make GCM sender id optional on Android
* Relax GMS dependency to 11.+

## 0.0.1

* Initial Release
