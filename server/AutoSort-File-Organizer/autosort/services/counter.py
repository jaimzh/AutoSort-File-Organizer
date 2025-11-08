import os
import json
from autosort.core.config import ConfigManager


LIFETIME_FILE = "lifetime_counts.json"
SESSION_FILE = "session_counts.json"


# ----------------------------
# JSON persistence helpers
# ----------------------------
# In counter.py

def _load_counts(file_path, rules):
    """Load counts from a JSON file, or initialize fresh counts with 0s."""
    
    # 1. Start with base structure
    counts = {"Total": 0}
    for category in rules.keys():
        counts[category] = 0
        
    # 2. If the file exists, load it and merge its counts
    if os.path.exists(file_path):
        with open(file_path, "r") as f:
            existing_counts = json.load(f)
            
            # Merge existing counts into the new structure
            for key, value in existing_counts.items():
                # Only update keys that already exist in the structure 
                # (Total, or a current category)
                if key in counts:
                    counts[key] = value
                # Optional: Handle old/retired categories not in current rules
                # else:
                #     counts[key] = value # Could keep old categories, or discard them
                    
    # 3. Return the merged counts (which now includes new categories at 0)
    return counts


def _save_counts(file_path, counts):
    """Save counts to a JSON file."""
    with open(file_path, "w") as f:
        json.dump(counts, f, indent=4)


# ----------------------------
# Lifetime Counter (updates JSON values directly)
# ----------------------------
def lifetime_counter_update(category, rules):
    """
    Update lifetime counter when a file is moved.
    Adds +1 to Total and the file's category in lifetime_counts.json.
    """
    counts = _load_counts(LIFETIME_FILE, rules)
    counts["Total"] += 1
    if category in counts:
        counts[category] += 1
    else:
        counts["Others"] += 1
    _save_counts(LIFETIME_FILE, counts)
    return counts


def lifetime_counter_get(rules):
    """Read the lifetime counter (doesn't scan folders)."""
    return _load_counts(LIFETIME_FILE, rules)


# TODO: code clean up and review of the commented sections
# ----------------------------
# Session Counter (scans folders to build counts)
# ----------------------------
# def session_counter_recount(destination_folder, rules):
#     """
#     Scan all destination folders and rebuild session_counts.json.
#     Reflects the actual current state of files on disk.
#     """
#     counts = {"Total": 0}
#     for category in rules.keys():
#         category_path = os.path.join(destination_folder, category)
#         if os.path.exists(category_path):
#             file_count = len([
#                 f for f in os.listdir(category_path)
#                 if os.path.isfile(os.path.join(category_path, f))
#             ])
#         else:
#             file_count = 0
#         counts[category] = file_count
#         counts["Total"] += file_count

#     _save_counts(SESSION_FILE, counts)
#     return counts


# def session_counter_get(rules):
#     """Read the last saved session snapshot from session_counts.json."""
#     return _load_counts(SESSION_FILE, rules)


# ----------------------------
# Example standalone usage
# ----------------------------
if __name__ == "__main__":
    config = ConfigManager("config.json")
    dest = config.get("destination_folder")
    rules = config.get("rules", {})

    # Lifetime counter demo
    print("📈 Updating lifetime counter...")
    updated = lifetime_counter_update("Videos", rules)
    print("Lifetime counts:", updated)

    # Session counter demo
    print("📊 Recounting session counter...")
    snapshot = session_counter_recount(dest, rules)
    print("Session counts:", snapshot)
