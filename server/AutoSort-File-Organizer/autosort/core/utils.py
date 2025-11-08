# autosort/core/utils.py
import os
import shutil
import time

def ensure_folder(path):
    os.makedirs(path, exist_ok=True)

def get_unique_filepath(dest_path):
    """
    If a file exists at dest_path, find a unique name by appending (1), (2), etc.
    """
    if not os.path.exists(dest_path):
        return dest_path

    base, ext = os.path.splitext(dest_path)
    counter = 1
    new_dest_path = f"{base}-({counter}){ext}"

    while os.path.exists(new_dest_path):
        counter += 1
        new_dest_path = f"{base} ({counter}){ext}"

    return new_dest_path

def safe_move(src_path, dest_folder, merge_duplicates=True, wait_before_copy=5, verify_delay=2):
    """Safely move a file by copying, verifying, then deleting the original."""
    ensure_folder(dest_folder)

    original_filename = os.path.basename(src_path)
    dest_path = os.path.join(dest_folder, original_filename)

    # Handle duplicates by renaming if merge_duplicates is False
    if not merge_duplicates:
        dest_path = get_unique_filepath(dest_path)
    
    final_filename = os.path.basename(dest_path)

    try:
        time.sleep(wait_before_copy)
        shutil.copy2(src_path, dest_path)
        time.sleep(verify_delay)

        src_size = os.path.getsize(src_path)
        dest_size = os.path.getsize(dest_path)

        if src_size == dest_size:
            os.remove(src_path)
            return dest_path, f"✅ Copied and verified: {original_filename} → {final_filename}"
        else:
            return src_path, f"⚠️ Size mismatch for {original_filename}, keeping original in place"

    except Exception as e:
        return src_path, f"❌ Error handling {original_filename}: {e}"

def fast_move(src_path, dest_folder, merge_duplicates=True):
    """Quickly move a file without safety checks (faster but less reliable)."""
    ensure_folder(dest_folder)

    original_filename = os.path.basename(src_path)
    dest_path = os.path.join(dest_folder, original_filename)

    # Handle duplicates by renaming if merge_duplicates is False
    if not merge_duplicates:
        dest_path = get_unique_filepath(dest_path)

    final_filename = os.path.basename(dest_path)

    try:
        shutil.move(src_path, dest_path)
        return dest_path, f"⚡ Moved: {original_filename} → {final_filename}"
    except Exception as e:
        return src_path, f"❌ Error moving {original_filename}: {e}"
    
def get_category_for_extension(ext, rules):
    """Return the matching category for an extension, or 'Others' if none match."""
    ext = ext.lower()
    for category, extensions in rules.items():
        if ext in [e.lower() for e in extensions]:
            return category
    return "Others"


def wait_until_stable(file_path, timeout=5, check_interval=0.2):
    """Wait until file size stops changing (Windows copy-paste safe)."""
    last_size = -1
    stable_count = 0
    start_time = time.time()

    while time.time() - start_time < timeout:
        try:
            size = os.path.getsize(file_path)
        except OSError:
            size = -1

        if size == last_size and size != -1:
            stable_count += 1
            if stable_count >= 2:  # stable across 2 checks
                return True
        else:
            stable_count = 0

        last_size = size
        time.sleep(check_interval)
    return False

    


def calculate_timeout(file_path):
    """Return a reasonable timeout based on file size in GB."""
    try:
        size_bytes = os.path.getsize(file_path)
    except OSError:
        return 10  # fallback if file isn’t accessible

    size_gb = size_bytes / (1024**3)  # bytes → GB

    if size_gb < 0.1:       # <100 MB
        return 1
    elif size_gb < 5:       # 100 MB – 1 GB
        return 3
    elif size_gb < 10:      # 1–10 GB
        return 7
    elif size_gb < 50:      # 10–50 GB
        return 10
    else:                   # >50 GB
        return 300          # 5 minutes
