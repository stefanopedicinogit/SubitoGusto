#!/bin/bash
set -e

# Install Flutter SDK
FLUTTER_VERSION="3.29.3"
git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git /tmp/flutter
export PATH="/tmp/flutter/bin:/tmp/flutter/bin/cache/dart-sdk/bin:$PATH"

# Precache web artifacts
flutter precache --web

# Enable web
flutter config --enable-web

# Get dependencies
flutter pub get

# Build for web with release optimizations
flutter build web --release --web-renderer html --base-href /
