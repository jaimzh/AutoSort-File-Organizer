# autosort/services/scanner.py
import os
import time
from autosort.core.config import ConfigManager
from autosort.core.utils import fast_move, get_category_for_extension, safe_move
from autosort.core.logger import get_logger
from autosort.services.counter import lifetime_counter_update

def scan_and_sort(stop_flag=None):
    """Manually scan the source folder and sort files according to config rules."""
    config = ConfigManager("config.json")
    source = config.get("source_folder")
    dest_base = config.get("destination_folder")
    rules = config.get("rules", {})
    exceptions = config.get("exceptions", [])
    wait_time = config.get("wait_before_copy")
    verify_delay = config.get("verify_delay")
    merge_duplicates = config.get("merge_duplicates", True)

    if not os.path.exists(source):
        print(f"❌ Source folder does not exist: {source}")
        return

    # Get the singleton logger instance
    logger = get_logger("logs.txt")
    
    start_entry = {
        "type": "scan",
        "action": "started",
        "message": f"Scan started: watching {source} folder",
        "status": "success",
        "file": None
    }
    logger.log(start_entry)
    print(f"🔍 Scanning {source} ...")

    for filename in os.listdir(source):
        
        # simple stop check
        if stop_flag and stop_flag.get("stop", False):
            print("🛑 Scan stopped by user.")
            
            end_entry = {
                "type": "scan",
                "action": "stopped",
                "message": "Scan stopped by user.",
                "status": "warning",
                "file": None
            }
            logger.log(end_entry)
            return
        
        file_path = os.path.join(source, filename)

        # Skip directories
        if os.path.isdir(file_path):
            continue

        # Skip temp/incomplete files
        if any(filename.endswith(ext) for ext in exceptions):
            print(f"⏩ Skipping temporary file: {filename}")
            
            log_entry = {
                "type": "scan",
                "action": "skipped",
                "message": f"Skipped temporary file: {filename}",
                "status": "warning",
                "file": {"name": filename, "category": None}
            }
            logger.log(log_entry)
            continue

        # Get extension and category
        _, ext = os.path.splitext(filename)
        category = get_category_for_extension(ext, rules)

        # Build destination folder
        dest_folder = os.path.join(dest_base, category)
        os.makedirs(dest_folder, exist_ok=True)

        # Perform move, safe or fast
        mode = config.get("mode", "safe")
        result_path, msg = None, ""

        if mode == "fast":
            result_path, msg = fast_move(file_path, dest_folder, merge_duplicates=merge_duplicates)
        else:
            result_path, msg = safe_move(
                src_path=file_path,
                dest_folder=dest_folder,
                merge_duplicates=merge_duplicates,
                wait_before_copy=wait_time,
                verify_delay=verify_delay
            )

        if "❌" in msg:
            status = "error"
            action = "failed"
        elif "⚠️" in msg or "Skipped" in msg:
            status = "warning"
            action = "skipped"
        else:
            status = "success"
            action = "moved"

        log_entry = {
            "type": "scan",
            "action": action,
            "message": msg,
            "status": status,
            "file": {"name": os.path.basename(file_path), "category": category}
        }
        logger.log(log_entry)
        print(msg)
        
        if status == "success":
            lifetime_counter_update(category, rules)

    end_entry = {
        "type": "scan",
        "action": "completed",
        "message": "Scan completed successfully.",
        "status": "success",
        "file": None
    }
    logger.log(end_entry)
    print("✅ Scan complete.")