import json
import os

class ConfigManager:
    def __init__(self, config_path="config.json"):
        self.config_path = config_path
        self._config = self._load_config()

    def _load_config(self):
        """Load config.json and expand paths."""
        if not os.path.exists(self.config_path):
            raise FileNotFoundError(f"Config file not found: {self.config_path}")

        with open(self.config_path, "r") as f:
            config = json.load(f)

        # Expand user paths (~)
        if "source_folder" in config:
            config["source_folder"] = os.path.expanduser(config["source_folder"])
        if "destination_folder" in config:
            config["destination_folder"] = os.path.expanduser(config["destination_folder"])

        return config

    def get(self, key, default=None):
        """Get a config value with optional default."""
        return self._config.get(key, default)

    def set(self, key, value):
        """Set a config value in memory and save to file."""
        self._config[key] = value
        self._save_config()

    def _save_config(self):
        """Write updated config back to file."""
        with open(self.config_path, "w") as f:
            json.dump(self._config, f, indent=2)

    def reload(self):
        """Reload config from file (useful if user edits manually)."""
        self._config = self._load_config()


