import threading
import time
import os
from autosort.core.config import ConfigManager
from autosort.services.scanner import scan_and_sort
from autosort.services.monitor import FileHandler, Observer
from autosort.core.logger import get_logger, close_logger

# main autostart class to manage scanning, monitoring and loading config file
class AutoSort:
    def __init__(self, config_path="config.json"):
        self.config = ConfigManager(config_path)
        self.observer = None
        self.stop_scan_flag = {"stop": False}

    def scan_now(self):
        """Run a one-time scan and sort."""
        print("📂 Running manual scan...")
        self.stop_scan_flag["stop"] = False
        scan_and_sort(stop_flag=self.stop_scan_flag)

    def stop_scan(self):
        """Stop an ongoing scan."""
        print("🛑 Stop requested.")
        self.stop_scan_flag["stop"] = True

    def start_monitor(self):
        """Start real-time monitoring."""
        if self.observer and self.observer.is_alive():
            print("⚠️ Monitor is already running.")
            return

        source = self.config.get("source_folder")
        if not os.path.exists(source):
            print(f"❌ Source folder does not exist: {source}")
            return

        print("👀 Starting monitor...")
        logger = get_logger()
        log_entry = {
            "type": "monitor",
            "action": "started",
            "message": f"Monitor started: watching {source} folder",
            "status": "success",
            "file": None
        }
        logger.log(log_entry)

        event_handler = FileHandler(self.config, logger)
        self.observer = Observer()
        self.observer.schedule(event_handler, source, recursive=False)
        self.observer.start()

    def stop_monitor(self):
        """Stop real-time monitoring."""
        if not self.observer or not self.observer.is_alive():
            print("⚠️ Monitor is not running.")
            return

        print("🛑 Stopping monitor...")
        self.observer.stop()
        self.observer.join()

        logger = get_logger()
        log_entry = {
            "type": "monitor",
            "action": "stopped",
            "message": "Monitor stopped.",
            "status": "success",
            "file": None
        }
        logger.log(log_entry)
        close_logger()
        print("✅ Monitor stopped.")