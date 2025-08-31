import time
import os
import shutil
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Define source and target folders
DOWNLOADS = os.path.expanduser("~/Downloads")
SORTED_BASE = os.path.expanduser("~/Documents/PROGRAMMING/Jaimz_code/python-scripts/Download-Organizer/sorted")

VIDEOS = os.path.join(SORTED_BASE, "Videos")
IMAGES = os.path.join(SORTED_BASE, "Images")
DOCS = os.path.join(SORTED_BASE, "Documents")
AUDIO = os.path.join(SORTED_BASE, "Audio")
ARCHIVES = os.path.join(SORTED_BASE, "Archives")
OTHERS = os.path.join(SORTED_BASE, "Others")

# Make sure target folders exist
for folder in [VIDEOS, IMAGES, DOCS, AUDIO, ARCHIVES, OTHERS]:
    os.makedirs(folder, exist_ok=True)

# File type mapping by extension
FILE_TYPES = {
    "Videos": [".mp4", ".mkv", ".mov", ".avi"],
    "Images": [".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"],
    "Documents": [".pdf", ".docx", ".txt", ".xlsx", ".pptx", ".doc", ".xml", ".ppt"],
    "Audio": [".mp3", ".wav", ".aac", ".flac", ".ogg"],
    "Archives": [".zip", ".rar", ".iso", ".7z", ".tar", ".gz"]
}

def move_file(src_path):
    filename = os.path.basename(src_path)
    name, ext = os.path.splitext(filename)

    # Decide destination based on extension
    if ext.lower() in FILE_TYPES["Videos"]:
        dest = VIDEOS
    elif ext.lower() in FILE_TYPES["Images"]:
        dest = IMAGES
    elif ext.lower() in FILE_TYPES["Documents"]:
        dest = DOCS
    elif ext.lower() in FILE_TYPES["Audio"]:
        dest = AUDIO
    elif ext.lower() in FILE_TYPES["Archives"]:
        dest = ARCHIVES
    else:
        dest = OTHERS

    # Wait in case file is still downloading
    time.sleep(5)

    try:
        dest_path = os.path.join(dest, filename)

        # Copy instead of move first (safe)
        shutil.copy2(src_path, dest_path)

        # Wait and compare file sizes
        time.sleep(2)
        src_size = os.path.getsize(src_path)
        dest_size = os.path.getsize(dest_path)

        if src_size == dest_size:
            os.remove(src_path)
            print(f"✅ Copied and verified {filename} -> {dest} (original deleted)")
        else:
            print(f"⚠️ Size mismatch for {filename}, keeping original in Downloads")

    except Exception as e:
        print(f"❌ Error handling {filename}: {e}")

class Handler(FileSystemEventHandler):
    def on_created(self, event):
        if not event.is_directory:
            move_file(event.src_path)

if __name__ == "__main__":
    print("📂 Download Organizer is running...")
    event_handler = Handler()
    observer = Observer()
    observer.schedule(event_handler, DOWNLOADS, recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
