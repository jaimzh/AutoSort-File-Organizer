import os
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

from autosort.core.config import ConfigManager
from autosort.core.utils import get_category_for_extension, safe_move, fast_move, wait_until_stable, calculate_timeout
from autosort.core.logger import get_logger
from autosort.services.counter import lifetime_counter_update


class FileHandler(FileSystemEventHandler):
    def __init__(self, config, logger):
        super().__init__()
        self.config = config
        self.rules = config.get("rules", {})
        self.exceptions = config.get("exceptions", [])
        self.dest_base = config.get("destination_folder")
        self.wait_time = config.get("wait_before_copy")
        self.verify_delay = config.get("verify_delay")
        self.merge_duplicates = config.get("merge_duplicates", True)
        self.logger = logger
        self.processed_files = set()

    def on_created(self, event):
        if not event.is_directory:
            self._process_file(event.src_path)

    def on_modified(self, event):
        if not event.is_directory:
            if event.src_path not in self.processed_files:
                time.sleep(1)
                self._process_file(event.src_path)

    def _process_file(self, file_path):
        if file_path in self.processed_files:
            return
            
        filename = os.path.basename(file_path)
        original_file_path = file_path

        if any(filename.endswith(ext) for ext in self.exceptions):
            log_entry = {
                "type": "monitor",
                "action": "skipped",
                "message": f"Skipped temporary file: {filename}",
                "status": "warning",
                "file": {"name": filename, "category": None}
            }
            self.logger.log(log_entry)
            print(log_entry["message"])
            return

        timeout = calculate_timeout(file_path)
        if not wait_until_stable(file_path, timeout):
            if os.path.exists(file_path):
                log_entry = {
                    "type": "monitor",
                    "action": "skipped",
                    "message": f"Skipped (file not stable after timeout): {filename}",
                    "status": "warning",
                    "file": {"name": filename, "category": None}
                }
                self.logger.log(log_entry)
                print(log_entry["message"])
                return

        _, ext = os.path.splitext(filename)
        category = get_category_for_extension(ext, self.rules)
        dest_folder = os.path.join(self.dest_base, category)
        os.makedirs(dest_folder, exist_ok=True)

        mode = self.config.get("mode", "safe")
        result_path, msg = None, ""
        if mode == "fast":
            result_path, msg = fast_move(file_path, dest_folder, merge_duplicates=self.merge_duplicates)
        else:
            result_path, msg = safe_move(
                src_path=file_path,
                dest_folder=dest_folder,
                merge_duplicates=self.merge_duplicates,
                wait_before_copy=self.wait_time,
                verify_delay=self.verify_delay,
            )

        if "❌" in msg:
            status = "error"
            action = "failed"
        elif "⚠️" in msg:
            status = "warning"
            action = "skipped"
        else:
            status = "success"
            action = "moved"

        log_entry = {
            "type": "monitor",
            "action": action,
            "message": msg,
            "status": status,
            "file": {"name": os.path.basename(original_file_path), "category": category}
        }
        self.logger.log(log_entry)
        print(msg)

        if status == "success":
            lifetime_counter_update(category, self.rules)
            self.processed_files.add(original_file_path)

# 🛑 This function is no longer needed. The Autosort class now handles the observer's lifecycle.
# def start_monitoring(stop_flag=None):
#    ... (rest of the old function)