// Firebase Cloud Messaging — web service worker.
// Required for Web Push to wake up while the SubitoGusto tab is closed.
//
// Fill in the placeholders below with your Firebase web-app config
// (Firebase Console → Project Settings → General → Your apps → Web app → SDK
// snippet → Config). These values are NOT secret — they're public identifiers.

importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDLe7OO7LrVu_HRVT2s32FbOGu_CNammhU',
  authDomain: 'subitogusto.firebaseapp.com',
  projectId: 'subitogusto',
  storageBucket: 'subitogusto.firebasestorage.app',
  messagingSenderId: '155082002517',
  appId: '1:155082002517:web:b10331a87f60e81c3f04dc',
});

const messaging = firebase.messaging();

// Background message handler — fires when the tab is closed or in the background.
// FCM auto-displays a notification when the payload includes a `notification`
// field (which our edge function sends), but we keep this handler in case we
// later switch to data-only payloads.
messaging.onBackgroundMessage((payload) => {
  // Intentionally minimal — the default OS notification is already shown.
  console.log('[firebase-messaging-sw] Background message:', payload);
});
