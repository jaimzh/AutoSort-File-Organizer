# autosort/services/scanner.py

import os
import time
from autosort.core.config import ConfigManager
from autosort.core.utils import fast_move, get_category_for_extension, safe_move



def scan_and_sort():
    """Manually scan the source folder and sort files according to config rules."""
    config = ConfigManager("config.json")
    source = config.get("source_folder")
    dest_base = config.get("destination_folder")
    rules = config.get("rules", {})
    exceptions = config.get("exceptions", [])
    wait_time = config.get("wait_before_copy", 5)
    verify_delay = config.get("verify_delay", 2)
    merge_duplicates = config.get("merge_duplicates", True)

    if not os.path.exists(source):
        print(f"❌ Source folder does not exist: {source}")
        return

    print(f"🔍 Scanning {source} ...")

    for filename in os.listdir(source):
        file_path = os.path.join(source, filename)

        # Skip directories
        if os.path.isdir(file_path):
            continue

        # Skip temp/incomplete files
        if any(filename.endswith(ext) for ext in exceptions):
            print(f"⏩ Skipping temporary file: {filename}")
            continue

        # Get extension and category
        _, ext = os.path.splitext(filename)
        category = get_category_for_extension(ext, rules)

        # Build destination folder
        dest_folder = os.path.join(dest_base, category)
        os.makedirs(dest_folder, exist_ok=True)

        # Perform move, safe or fast
        mode = config.get("mode", "safe")
        if mode == "fast":
            fast_move(file_path, dest_folder, merge_duplicates=merge_duplicates)
        else: 
            safe_move(
            src_path=file_path,
            dest_folder=dest_folder,
            merge_duplicates=merge_duplicates,
            wait_before_copy=wait_time,
            verify_delay=verify_delay
            
        )


    print("✅ Scan complete.")


if __name__ == "__main__":
    scan_and_sort()

