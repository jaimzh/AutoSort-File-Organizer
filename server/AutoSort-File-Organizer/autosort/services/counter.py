import os
import json
from autosort.core.config import ConfigManager


LIFETIME_FILE = "lifetime_counts.json"
SESSION_FILE = "session_counts.json"




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


