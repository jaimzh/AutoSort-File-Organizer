# autosort/services/monitor.py

import os
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

from autosort.core.config import ConfigManager
from autosort.core.utils import get_category_for_extension, safe_move, fast_move
from autosort.core.logger import Logger
from autosort.services.counter import lifetime_counter_update


class FileHandler(FileSystemEventHandler):
    """Handle file system events for auto-sorting."""

    def __init__(self, config):
        super().__init__()
        self.config = config
        self.rules = config.get("rules", {})
        self.exceptions = config.get("exceptions", [])
        self.dest_base = config.get("destination_folder")
        self.wait_time = config.get("wait_before_copy", 5)
        self.verify_delay = config.get("verify_delay", 2)
        self.merge_duplicates = config.get("merge_duplicates", True)
        self.logger = Logger("logging.txt")  # ✅ log file

    def on_created(self, event):
        """Triggered when a new file/folder is created in the monitored directory."""
        if event.is_directory:
            return  # Ignore new directories

        filename = os.path.basename(event.src_path)

        # Skip temp/incomplete files
        if any(filename.endswith(ext) for ext in self.exceptions):
            msg = f"⏩ Skipping temporary file: {filename}"
            print(msg)
            self.logger.log(msg)
            return

        # Get category for extension
        _, ext = os.path.splitext(filename)
        category = get_category_for_extension(ext, self.rules)

        # Build destination folder
        dest_folder = os.path.join(self.dest_base, category)
        os.makedirs(dest_folder, exist_ok=True)

        # Perform move based on mode
        mode = self.config.get("mode", "safe")
        if mode == "fast":
            fast_move(event.src_path, dest_folder, merge_duplicates=self.merge_duplicates)
            msg = f"⚡ Fast-moved: {filename} → {category}"
        else:
            safe_move(
                src_path=event.src_path,
                dest_folder=dest_folder,
                merge_duplicates=self.merge_duplicates,
                wait_before_copy=self.wait_time,
                verify_delay=self.verify_delay,
                
            )
            msg = f"🛡️ Safely moved: {filename} → {category}"

        print(msg)
        self.logger.log(msg)
        lifetime_counter_update(category, self.rules)



def start_monitoring():
    """Start monitoring the source folder for new files."""
    config = ConfigManager("config.json")
    source = config.get("source_folder")

    if not os.path.exists(source):
        print(f"❌ Source folder does not exist: {source}")
        return

    print(f"👀 Monitoring folder: {source}")
    event_handler = FileHandler(config)
    observer = Observer()
    observer.schedule(event_handler, source, recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)  # Keep alive
    except KeyboardInterrupt:
        print("🛑 Stopping monitor...")
        observer.stop()

    observer.join()


if __name__ == "__main__":
    start_monitoring()
