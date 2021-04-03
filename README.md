# DayTrip Documentation

## System Requirements

### Hardware
- 600mb to 2.8gb disk space depending on operating system

### Software
- Windows 7 SP1 (64-bit) or later, MacOS (64-bit), Linux (64-bit), or Chrome OS (64-bit) with Linux (Beta) turned on
- Tools: Flutter depends on these command-line tools being available in your environment.
  - bash, curl, git 2.x, mkdir, rm, unzip, which, xz-utils

## Installation Instructions
- Download and unzip the latest flutter sdk
- Add flutter to your environment path for use globally on your machine (for full instructions see [this step](https://flutter.dev/docs/get-started/install/windows#get-the-flutter-sdk) in the flutter getting started documentation)]
- Download and install Android Studio and optionally VSCode
  - Follow android studio setup instructions and proceed to download + install an android emulator via the AVD manager 
- Run `flutter doctor` to ensure development environment is setup correctly
- Clone the DayTrip repository
- Navigate to project directory and run flutter by opening and running in VSCode or Android studio, or by executing `flutter run` in the project terminal

### Connect Firebase Project
- Follow respective Android/IOS [setup instructions](https://firebase.google.com/docs/flutter/setup?platform=android) provided by Firebase
- Generate SHA1 signing report for Android/IOS and add the firebase project via the firebase console (otherwise the connection from your development machine will be rejected by firebase). For further information see these resources: [android](https://medium.com/mindorks/generating-sha-1-for-android-the-simplest-way-a3a9a92c36e7), [IOS](https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/Procedures/Procedures.html).


For more help getting started with Flutter, view their
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
