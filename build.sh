#!/bin/bash
set -e

# Generate .env from Vercel environment variables
cat > .env <<EOF
SUPABASE_URL=${SUPABASE_URL}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
SUPA_PWD=${SUPA_PWD}
SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_ROLE_KEY}
STRIPE_PUBLISHABLE_KEY=${STRIPE_PUBLISHABLE_KEY}
STRIPE_SECRET_KEY=${STRIPE_SECRET_KEY}
STRIPE_WEBHOOOK_KEY=${STRIPE_WEBHOOOK_KEY}
CODICE_BACKUP_STRIPE_MARC=${CODICE_BACKUP_STRIPE_MARC}
EOF

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
