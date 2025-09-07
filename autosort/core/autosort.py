# autosort/core/autosort.py

import threading
import time
import os
from autosort.core.config import ConfigManager
from autosort.services.scanner import scan_and_sort
from autosort.services.monitor import start_monitoring

# main autostart class to manage scanning, monitoring and loading config file
class AutoSort:
    def __init__(self, config_path="config.json"):
        self.config = ConfigManager(config_path)
        self.monitor_thread = None
        self.observer = None 
        self.running = False

    def scan_now(self):
        """Run a one-time scan and sort."""
        print("📂 Running manual scan...")
        scan_and_sort()

    def start_monitor(self):
        """Start real-time monitoring in a background thread."""
        if self.running:
            print("⚠️ Monitor is already running.")
            return

        print("👀 Starting monitor...")
        self.running = True

        def run_monitor():
            # Use start_monitoring() from monitor.py, but keep reference to observer
            from autosort.services.monitor import FileHandler, Observer

            source = self.config.get("source_folder")
            if not os.path.exists(source):
                print(f"❌ Source folder does not exist: {source}")
                return

            event_handler = FileHandler(self.config)
            self.observer = Observer()
            self.observer.schedule(event_handler, source, recursive=False)
            self.observer.start()

            try:
                while self.running:
                    time.sleep(1)
            except Exception as e:
                print(f"❌ Monitor crashed: {e}")
            finally:
                if self.observer:
                    self.observer.stop()
                    self.observer.join()

        # Run monitor in background thread so we can stop it later
        self.monitor_thread = threading.Thread(target=run_monitor, daemon=True)
        self.monitor_thread.start()

    def stop_monitor(self):
        """Stop real-time monitoring."""
        if not self.running:
            print("⚠️ Monitor is not running.")
            return

        print("🛑 Stopping monitor...")
        self.running = False
        if self.observer:
            self.observer.stop()
            self.observer.join()
        if self.monitor_thread:
            self.monitor_thread.join()
        print("✅ Monitor stopped.")



