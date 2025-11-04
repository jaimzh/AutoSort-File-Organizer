# autosort/services/get_logs_and_counts.py
import os
import json

# Path to your logs folder
LOGS_DIR = os.path.join(os.path.dirname(__file__), "..", "logs")

#lifetimem count directory 
COUNTS_DIR = os.path.join(os.path.dirname(__file__), "..", "..")

# File names
LOGS_FILE = os.path.join(LOGS_DIR, "logs.txt")
LOG_FILE = "log.txt"
LIFETIME_COUNTS = "lifetime_counts.json"
SESSION_COUNTS = "session_counts.json"

def _read_json_stream(file_path: str):
    """Read a JSON stream file, yielding each JSON object."""
    if not os.path.exists(file_path):
        return
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f:
            try:
                yield json.loads(line)
            except json.JSONDecodeError:
                continue

def get_logs(log_type: str):
    """Return a list of log entries for a given type ('scan' or 'monitor')."""
    logs = []
    for entry in _read_json_stream(os.path.join(LOGS_DIR, LOG_FILE)):
        if entry.get("type") == log_type:
            logs.append(entry)
    return logs


def get_scan_logs():
    """Return the contents of scanner_logging.txt."""
    return get_logs("scan")

def get_monitor_logs():
    """Return the contents of monitor_logging.txt."""
    return get_logs("monitor")


def get_lifetime_counts() -> dict:
    """Return the contents of lifetime_counts.json as dict."""
    return _read_json(os.path.join(COUNTS_DIR, LIFETIME_COUNTS))



def reset_lifetime_counts() -> dict:
    default_counts = {
        "Total": 0,
        "Videos": 0,
        "Images": 0,
        "Documents": 0,
        "Audio": 0,
        "Archives": 0,
        "Others": 0,
        "Subtitles": 0,
    }

    file_path = os.path.join(COUNTS_DIR, LIFETIME_COUNTS)
    try:
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(default_counts, f, indent=4)
    except OSError as e:
        print(f"Error writing lifetime counts: {e}")
        return {}

    return default_counts







def get_session_counts() -> dict:
    """Return the contents of session_counts.json as dict."""
    return _read_json(os.path.join(LOGS_DIR, SESSION_COUNTS))


def _read_json(file_path: str) -> dict:
    """Read a JSON file, return dict, or empty dict if missing/corrupt."""
    if not os.path.exists(file_path):
        return {}
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, OSError):
        return {}
    
    
def read_logs_file():
    """Read all logs from logs.txt and return as a list of JSON objects."""
    logs = []
    if not os.path.exists(LOGS_FILE):
        return logs

    with open(LOGS_FILE, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:  # skip empty lines
                try:
                    logs.append(json.loads(line))
                except json.JSONDecodeError:
                    # skip bad lines instead of crashing
                    continue
    return logs


def clear_logs():
    """Clear all logs from logs.txt and reset session counts."""
    # Clear logs.txt
    with open(LOGS_FILE, "w", encoding="utf-8") as f:
        f.write("")

    # Reset session_counts.json too (so each session starts fresh)
    session_counts_path = os.path.join(LOGS_DIR, SESSION_COUNTS)
    with open(session_counts_path, "w", encoding="utf-8") as f:
        json.dump({}, f)

if __name__ == "__main__":
    print("🔍 Testing log + count readers...\n")

    # Assuming you've run the scanner and monitor at least once
    scan_logs = get_scan_logs()
    print("--- SCAN LOGS ---")
    for log in scan_logs:
        print(log)