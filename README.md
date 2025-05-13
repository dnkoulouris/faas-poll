A cross-platform **Flutter** app for organizing and participating in football match polls. Users can create and vote on match formats: **5x5**, **7x7**, or **11x11**.

---

## 🧠 What This App Does

This app helps football players coordinate matches by allowing:

- 🗳 Creating polls for upcoming matches
- ✅ Joining polls to confirm attendance
- 👥 Viewing participants in real time
- 🧑‍💼 Users can remove participants

---

## 🛠 Features

- 🔥 Firebase Firestore backend
- 📱 Cross-platform support (currently only for Web)
- ⚡ Real-time participation updates
- 🧱 Built with clean and modular Dart/Flutter architecture
- 🌐 Deployed via Firebase Hosting for the Web

---

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/dnkoulouris/faas-poll.git
cd faas-poll
```

### 2. Run locally
```bash
flutter run -d chrome
```

### 3. Build & Deploy
```bash
flutter clean
flutter build web --wasm --release
firebase deploy
```


