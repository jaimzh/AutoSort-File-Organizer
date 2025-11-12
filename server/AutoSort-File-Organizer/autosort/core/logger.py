import os
import json
import threading
from datetime import datetime


LOGS_DIR = os.path.join(os.path.dirname(__file__), "..", "logs")
os.makedirs(LOGS_DIR, exist_ok=True)  

_logger_instance = None
_logger_lock = threading.Lock()

class Logger:
    """A logger class that writes structured logs to a file."""
    def __init__(self, file_name):
        self.file_path = os.path.join(LOGS_DIR, file_name)
        # The file is opened once and stays open
        self._file = open(self.file_path, "a", encoding="utf-8")

    def log(self, log_entry):
        """Log a message to the file with a timestamp."""
        with _logger_lock:
            log_entry["timestamp"] = datetime.now().isoformat()
            # Use JSON format for structured logging
            json.dump(log_entry, self._file)
            self._file.write("\n")
            self._file.flush() 
            
    def clear(self):
            """Clear the log file (truncate contents)."""
            with _logger_lock:
                self._file.close()
                # Open in write mode to truncate, then reopen in append mode
                open(self.file_path, "w").close()
                self._file = open(self.file_path, "a", encoding="utf-8")



    def close(self):
        """Close the log file handle."""
        if self._file and not self._file.closed:
            self._file.close()

def get_logger(file_name="logs.txt"):
    """
    Returns a singleton Logger instance.
    This ensures all parts of the application use the same logger.
    """
    global _logger_instance
    with _logger_lock:
        if _logger_instance is None:
            _logger_instance = Logger(file_name)
        return _logger_instance

def close_logger():
    """
    Explicitly closes the singleton logger instance.
    """
    global _logger_instance
    with _logger_lock:
        if _logger_instance:
            _logger_instance.close()
            _logger_instance = None