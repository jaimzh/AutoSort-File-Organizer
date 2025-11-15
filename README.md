

# 🧠 **AutoSort — The Neat Freak Your Computer Needs (A Smart Desktop Utility App)**

AutoSort is a **full-stack desktop utility app** built to keep your computer clean, organized, and clutter-free — automatically.
Think of it as the **neat freak your computer has always needed**. It sorts files by their file type into proper categories and keeps everything tidy with zero stress.

AutoSort combines:

* A modern, responsive **Flutter desktop client**
* A fast, reliable **Python backend**
* Real-time monitoring and intelligent file organization

Its mission is simple:
**Bring structure to digital chaos — with speed, safety, and style.**

---

## 🚀 Features

### 🗂 Smart File Organization

* Automatically sorts files by type, extension, or custom logic
* Detects duplicates with merge/unmerge controls
* Safe file operations: copy → verify → finalize
* Flexible categories: Documents, Media, Code, Archives, etc.

### 📊 Real-Time Monitoring

* Live file count by category
* Dashboard refresh & status indicators
* Change detection as files are added/removed

### 🖥 Clean & Modern Desktop App

* Built with Flutter for Windows, macOS, and Linux
* Lucide icons + custom theming
* Snackbar notifications & smooth UX
* Settings page ready for future appearance and behavior options

### ⚡ Lightweight Python Backend

* Directory scanning & file categorization
* Duplicate detection & safe handling
* Fast local REST API (Flask/FastAPI depending on your final setup)
* Runs as a simple, dependable local service

---

## 🏗 Project Structure

```
AUTOSORT/
│
├── client/
│   └── autosort/                # Flutter desktop utility app
│       ├── lib/                 # UI, pages, widgets, services
│       ├── assets/              # Images, icons, fonts
│       ├── windows/ linux/ macos/
│       ├── pubspec.yaml
│       └── README.md            # (to be added later)
│
├── server/
│   └── AutoSort-File-Organizer/ # Python backend
│       ├── src/ or modules/     # File organization logic
│       ├── main.py              # API entry point
│       └── README.md            # (to be added later)
│
└── README.md                    # Root overview (this file)
```

---

## 🔧 Tech Stack

### **Frontend (Utility App)**

* Flutter
* Dart
* Lucide Icons
* Custom theme
* REST API client

### **Backend (Organizer Service)**

* Python
* FastAPI 
* OS-level file operations
* Directory scanning & duplicate detection

---

## 📦 Installation & Setup

### 1️⃣ Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/autosort.git
cd autosort
```

### 2️⃣ Start the backend (Python)

```bash
cd server/AutoSort-File-Organizer
pip install -r requirements.txt
python main.py
```

### 3️⃣ Start the Flutter client

```bash
cd client/autosort
flutter pub get
flutter run -d windows   # or macos, linux
```

---

## 💡 How AutoSort Works

1. The Python backend scans your target folders
2. It categorizes files into predefined types
3. AutoSort performs safe operations (copy → verify → replace)
4. The Flutter client displays live stats, categories, and actions
5. You control operations such as:

   * Sort Files
   * Reset Directory
   * Merge/Unmerge Duplicates
   * Refresh Counts
   * Monitor file changes

AutoSort stays lightweight, fast, and dependable — exactly how a utility app should be.

---

## 🗺 Roadmap

* [ ] Custom sorting rules (patterns, extension groups)
* [ ] Background-service mode with system tray
* [ ] Activity logs & notifications
* [ ] User-defined categories
* [ ] Advanced duplicate detection
* [ ] Plugin/add-on system

---

## 🤝 Contributing

Contribution guidelines will be added in v1.0.
Pull requests are welcome once the architecture is stabilized.

---

## 📜 License

MIT License — free for personal and commercial use.

---

## ⭐ Final Notes

AutoSort is designed to be a **practical, everyday desktop utility** — install it once and let it silently keep your system neat, organized, and stress-free.

---

<!-- If you want, I can:

✅ Add badges
✅ Design a banner/logo
✅ Generate screenshots placeholders
✅ Prepare the sub-folder READMEs (client + server)

Just say the word. -->
