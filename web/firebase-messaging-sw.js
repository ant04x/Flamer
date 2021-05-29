importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-analytics.js");

firebase.initializeApp({
    apiKey: "AIzaSyAXHhbN1UukQ8krXPRbLcQlTe5sSy2D0H8",
    authDomain: "flamer-89f12.firebaseapp.com",
    databaseURL: "https://flamer-89f12-default-rtdb.firebaseio.com",
    projectId: "flamer-89f12",
    storageBucket: "flamer-89f12.appspot.com",
    messagingSenderId: "505657173480",
    appId: "1:505657173480:web:35ba35eab60fe3cd2db05d",
    measurementId: "G-D5J4VP3BVQ"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = payload.data.title;
  const notificationOptions = {
    body: payload.data.body,
    icon: '/icons/Icon-512.png',
    // badge: payload.data.badge,
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
