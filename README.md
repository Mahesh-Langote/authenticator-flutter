# Flutter Authenticator POC 🔐

A modern, highly-customized Authenticator Proof of Concept (POC) built with Flutter. This app generates Time-Based One-Time Passwords (TOTP) for Two-Factor Authentication (2FA) and is designed to be a sleek alternative to existing authenticator apps like Google or Microsoft Authenticator.

### Demo
<video src="doc/screen-record.mp4" controls="controls" muted="muted" width="300"></video>

## ✨ Features

- **Custom UI & UX**: Built from scratch without relying on default Material widgets. Features a sleek dark mode theme, glassmorphism elements, and highly interactive animations.
- **Secure Storage**: Uses `flutter_secure_storage` to encrypt and store all TOTP secrets securely on the device's native KeyStore/Keychain.
- **QR Code Scanning**: Quickly add accounts by scanning standard `otpauth://` QR codes with an immersive animated scanning laser overlay.
- **Manual Entry**: Validate and add accounts manually using a Base32 secret key.
- **State Management**: Built using the `BLoC` pattern for clean separation of business logic and UI.
- **Interactive Animations**: Includes staggered list loading, a custom rotating sweeping gradient border on empty states, and dynamic circular countdown rings.
- **Edit & Delete**: Sleek context menus to easily manage, rename, or remove your authenticator tokens.

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: `flutter_bloc`
- **TOTP Generation**: `otp` & `base32`
- **QR Scanner**: `mobile_scanner`
- **Storage**: `flutter_secure_storage`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.10.3 or higher)
- Android Studio / Xcode for emulators

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Mahesh-Langote/authenticator-flutter.git
   cd authenticator-flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

> **Note for Android developers**: This project uses `flutter_secure_storage` which requires `minSdk 24` or higher in `android/app/build.gradle`.

## 🎨 UI Highlights

- **No generic widgets**: Buttons, text fields, and cards were built to feel premium and unique.
- **Moving Gradient Border**: An attention-grabbing rotating sweep gradient animates around the "Add Account" button when your vault is empty.
- **Slide-in Staggered Cards**: Cards gracefully cascade into view upon launch.

## 🤝 Contributing
Since this is a Proof of Concept, feel free to fork the repository and experiment with adding features like iCloud/Google Drive backup, Biometric App Unlock, or HOTP support!

## 📄 License
This project is open-source and available under the MIT License.
