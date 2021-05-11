importScripts("https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js");
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
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});