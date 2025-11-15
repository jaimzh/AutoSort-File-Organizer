
# 🧠 **AutoSort — The Neat Freak Your Computer Needs (A Smart Desktop Utility App)**

AutoSort is a **full-stack desktop utility app** built to keep your computer clean, organized, and clutter-free — automatically.
Think of it as the **neat freak your computer has always needed**. It sorts files into proper categories, and keeps everything in order with zero stress.

AutoSort combines:

* A modern, responsive **Flutter desktop client**
* A fast, reliable **Python backend**
* Real-time file monitoring and cleanup automation

Its mission is simple:
**Bring structure to digital chaos — with speed, safety, and style.**

---

## 🚀 Features

### 🗂 Smart File Organization

* Automatically sorts files by type, extension, or custom rules
* Detects duplicates with merge/unmerge controls
* Safe file operations: copy → verify → finalize
* Customizable categories (Documents, Media, Code, Archives, etc.)

### 📊 Real-Time Monitoring

* Live file count by category
* Dashboard refresh & status indicators
* Tracks changes as they happen

### 🖥 Clean & Modern Desktop App

* Built with Flutter for Windows, macOS & Linux
* Sleek UI with Lucide icons and custom theming
* Snackbar notifications & smooth UX
* Future-proof settings page for appearance and behavior

### ⚡ High-Performance Rust Backend

* Efficient directory scanning
* Safe concurrent file operations
* Simple JSON API exposed to Flutter
* Designed to run as a lightweight background service

---

## 🏗 Project Structure

```
AUTOSORT-FULL-PROJECT/
│
├── client/
│   └── autosort/                # Flutter desktop utility app
│       ├── lib/                 # UI, pages, state, widgets, API services
│       ├── assets/              # App images, icons, fonts
│       ├── windows/ linux/ macos/ 
│       ├── pubspec.yaml
│       └── README.md            # To be added later
│
├── server/
│   └── AutoSort-File-Organizer/ # Rust backend
│       ├── src/                 
│       ├── Cargo.toml
│       └── README.md            # To be added later
│
└── README.md                    # Root overview (this file)
```

---

## 🔧 Tech Stack

### **Frontend (Utility App)**

* Flutter
* Dart
* Lucide Icons
* Custom Theme System
* HTTP Client for backend sync

### **Backend (Organizer Service)**

* Rust
* Tokio (async runtime)
* File I/O, scanning, metadata collection
* REST-style JSON API

---

## 📦 Installation & Setup

### 1️⃣ Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/autosort.git
cd autosort
```

### 2️⃣ Run the client (Flutter)

```bash
cd client/autosort
flutter pub get
flutter run -d windows   # or macos, linux
```

### 3️⃣ Run the backend (Rust)

```bash
cd server/AutoSort-File-Organizer
cargo run
```

---

## 💡 How AutoSort Works

1. The Rust backend monitors your target folders
2. It categorizes files into well-defined types
3. AutoSort performs safe operations (copy → verify → replace)
4. The Flutter client displays live stats, categories, and actions
5. You control operations like:

   * Sort Files
   * Reset Directory
   * Merge/Unmerge Duplicates
   * Refresh Counts
   * Monitor changes

AutoSort stays lightweight, fast, and dependable — exactly how a utility app should be.

---

## 🗺 Roadmap

* [ ] Custom sorting rules (regex, patterns, extension groups)
* [ ] Background-service mode with tray icon
* [ ] Notifications & log viewer
* [ ] Cloud sync for sorting profiles
* [ ] Advanced duplicate detection
* [ ] Plugin support for specialized file handlers

---

## 🤝 Contributing

Contribution guidelines will be added in v1.0.
Pull requests are welcome once the architecture is stabilized.

---

## 📜 License

MIT License — free for commercial and personal use.

---

## ⭐ Final Notes

AutoSort is built to be a **practical everyday utility** — the kind you install once and let it silently keep your digital life tidy.


<!-- 
Stuff i might do later create:

✨ A logo/banner for the project
✨ GitHub badges
✨ A more visual “screenshots & demo” section
✨ README files for `client/` and `server/` folders
 -->

