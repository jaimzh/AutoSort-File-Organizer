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


def safe_move(
    src_path, dest_folder, merge_duplicates=True, wait_before_copy=5, verify_delay=2
):
    """
    Safely move a file by copying, verifying, then deleting the original.

    This is used in AutoSort's 'Safe Mode' to prevent data loss or corruption.
    It performs a careful move operation:
    1. Waits before copying to ensure file isn't still being written.
    2. Copies the file instead of moving it directly.
    3. Waits a bit, then verifies the copied file by comparing file sizes.
    4. If verification passes, deletes the original file.
    5. If verification fails, keeps the original and logs a warning.
    """

    ensure_folder(dest_folder)

    original_filename = os.path.basename(src_path)
    dest_path = os.path.join(dest_folder, original_filename)

    if not merge_duplicates:
        dest_path = get_unique_filepath(dest_path)

    final_filename = os.path.basename(dest_path)

    try:
        # Step 1: Wait before copying to ensure file is stable (e.g. not still downloading)
        time.sleep(wait_before_copy)
        # Step 2: Perform the copy instead of a move (non-destructive)
        shutil.copy2(src_path, dest_path)
        # Step 3: Wait briefly to ensure the copy process is complete and file system updates
        time.sleep(verify_delay)
        # Step 4: Verify integrity by comparing file sizes
        src_size = os.path.getsize(src_path)
        dest_size = os.path.getsize(dest_path)
        # Step 5A: If both files are the same size, delete the original (safe to clean up)
        if src_size == dest_size:
            os.remove(src_path)
            return (
                dest_path,
                f"✅ Copied and verified: {original_filename} → {final_filename}",
            )
        # Step 5B: If size mismatch, assume incomplete copy — keep the original
        else:
            return (
                src_path,
                f"⚠️ Size mismatch for {original_filename}, keeping original in place",
            )

    except Exception as e:
        return src_path, f"❌ Error handling {original_filename}: {e}"


def fast_move(src_path, dest_folder, merge_duplicates=True):
    """
    Quickly move a file without safety checks (used in 'Fast Mode').

    This prioritizes speed over safety — ideal for smaller files or when
    performance is more important than verification.

    Steps:
    1. Ensure destination folder exists.
    2. Handle duplicates if necessary.
    3. Move the file directly using shutil.move().
    4. Return success or failure message.

    """
    ensure_folder(dest_folder)

    original_filename = os.path.basename(src_path)
    dest_path = os.path.join(dest_folder, original_filename)

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

    if size_gb < 0.1:  # <100 MB
        return 1
    elif size_gb < 5:  # 100 MB – 1 GB
        return 3
    elif size_gb < 10:  # 1–10 GB
        return 7
    elif size_gb < 50:  # 10–50 GB
        return 10
    else:  # >50 GB
        return 300  # 5 minutes
