from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
from autosort.core.autosort import AutoSort
from autosort.core.config import ConfigManager
from autosort.services.get_logs_and_counts import get_scan_logs, get_monitor_logs, get_lifetime_counts, read_logs_file, clear_logs
from fastapi import HTTPException


app = FastAPI(title="AutoSort API", version="1.0.0")

autosort = AutoSort(config_path="config.json")



class ExceptionsUpdate(BaseModel):
    exceptions: list[str]

class ConfigUpdate(BaseModel):
    source_folder: str | None = None
    destination_folder: str | None = None
    mode: str | None = None

class RulesUpdate(BaseModel): 
    rules: dict[str, list[str]] 
    

class RuleCategory(BaseModel): 
    category:  str 
  
class FullConfigUpdate(BaseModel):
    config: dict  
    
class WaitBeforeCopyUpdate(BaseModel):
    wait_before_copy: int

class VerifyDelayUpdate(BaseModel):
    verify_delay: int
    
class ManageDuplicatesUpdate(BaseModel): 
    merge_duplicates: bool
  
@app.get("/")
def read_root():
    return {"message": "alright so this is the autosort api"}
#just to check if api is connected or not
@app.get("/health")
def health():
    return {"status": "ok"}

#this is to get the enire config file used in rules and settings page
@app.get("/config")
def get_config():
    return autosort.config._config


# this is a full config update
@app.put("/config/full_update")
async def full_update_config(update: FullConfigUpdate):
    """
    Completely overwrite the current configuration using AutoSort's ConfigManager.
    """
    try:
        # Clear existing config and replace with new one
        autosort.config._config.clear()
        autosort.config._config.update(update.config)

        # Use ConfigManager's internal mechanism to save (through .set)
        for key, value in update.config.items():
            autosort.config.set(key, value)

        return {
            "message": "Full configuration updated successfully",
            "config": autosort.config._config
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    

@app.put("/config/reset_defaults")
async def reset_config_to_defaults():
    """
    Reset the AutoSort configuration back to its default settings.
    """
    try:
        default_config = {
            "source_folder": r"C:\Users\Jaimz\Downloads\testfolder",
            "destination_folder": r"C:\Users\Jaimz\Downloads\testfolder",
            "rules": {
                "Videos": [".mp4", ".mkv", ".mov", ".avi"],
                "Images": [".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"],
                "Documents": [".docx", ".pdf"],
                "Audio": [".mp3", ".wav", ".aac", ".flac", ".ogg"],
                "Archives": [".zip", ".rar", ".iso", ".7z", ".tar", ".gz"],
                "Others": [],
                "Subtitles": [".srt"],
            },
            "exceptions": [
                ".crdownload",
                ".part",
                ".tmp",
                ".temp",
                ".fdmdownload",
            ],
            "wait_before_copy": 1,
            "verify_delay": 2,
            "mode": "fast",
            "merge_duplicates": False,
            "dark_mode": True,
        }

        # Replace the entire config with defaults
        autosort.config._config.clear()
        autosort.config._config.update(default_config)

        # Persist to disk or internal manager
        for key, value in default_config.items():
            autosort.config.set(key, value)

        return {
            "message": "✅ Configuration reset to defaults successfully",
            "config": autosort.config._config,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
   
   
#this is to change a specific part or modify a specific propertity in config file, used in autosort, rules, setting's page
@app.patch("/config/update")
async def update_config(update: ConfigUpdate):
    if update.source_folder is not None:
        autosort.config.set("source_folder", update.source_folder)
    if update.destination_folder is not None:
        autosort.config.set("destination_folder", update.destination_folder)
    if update.mode is not None:
        autosort.config.set("mode", update.mode)

    return {
        "message": "Config updated/deleted successfully",
        "config": autosort.config._config  
    }

# ✅ Get only extensions (rules)
@app.get("/config/exceptions")
async def get_exceptions():
    """
    Get the current list of exceptions from the configuration.
    """
    try:
        exceptions = autosort.config.get("exceptions") or []
        return {
            "message": "✅ Exceptions fetched successfully",
            "exceptions": exceptions
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.patch("/config/exceptions")
async def update_exceptions(update: ExceptionsUpdate):
    """
    Update or replace the list of exceptions in the configuration.
    """
    try:
        # Replace the exceptions list with the new one
        autosort.config.set("exceptions", update.exceptions)

        return {
            "message": "✅ Exceptions updated successfully",
            "exceptions": autosort.config.get("exceptions")
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))





@app.patch("/config/rules")
async def update_rules(update: RulesUpdate):
    current_rules = autosort.config.get("rules") or {}

    # Merge existing + new
    for category, extensions in update.rules.items():
        current_rules[category] = extensions

    autosort.config.set("rules", current_rules)

    return {
        "message": "Rules merged successfully",
        "config": autosort.config._config
    }

   
   
@app.patch("/config/rules/delete_category")
async def update_rules(update: RuleCategory):
    current_rules = autosort.config.get("rules") or {}
    category_name = str(update.category)
    
    if category_name in current_rules:    
        current_rules.pop(category_name)
        autosort.config.set("rules", current_rules)
    else:
        return {
            "message": f"Category '{category_name}' does not exist",
            "config": autosort.config._config
        }

    return {
        "message": "Rules deleted successfully",
        "config": autosort.config._config
    }
    
    
   
    
#used in autosort page
@app.post("/scan/start")
def scan_folder():
    autosort.scan_now()
    return {"message": "Manual scan completed"}
    

@app.post("/scan/stop")
def stop_scan():
    autosort.stop_scan()
    return {"message": "Scan stop requested"}

@app.post("/monitor/start")
def start_monitor():
    autosort.start_monitor()
    return {"message": "Monitoring started"}

@app.post("/monitor/stop")
def stop_monitor():
    autosort.stop_monitor()
    return {"message": "Monitoring stopped"}

#used in dashboard, recent activity part and logs page
@app.get("/logs")
def get_logss():
    return {"logs": read_logs_file()}


@app.delete("/logs/clear")
def clear_logs_endpoint():
    clear_logs()
    return {"message": "Logs and session counts cleared"}



#used in dashboard page
@app.get("/counts")
def get_counts():
    return get_lifetime_counts()




@app.get("/config/dark_mode")
def get_dark_mode():
    try:
        value = autosort.config.get("dark_mode", False)
        return {"dark_mode": value}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.patch("/config/dark_mode")
def update_dark_mode(value: bool):
    try:
        autosort.config.set("dark_mode", value)
        return {"message": "Dark mode updated", "dark_mode": value}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))



@app.patch("/config/wait_before_copy")
def get_wait_before_copy(update: WaitBeforeCopyUpdate):
    try: 
        autosort.config.set("wait_before_copy", update.wait_before_copy)
        return {"message": "wait_before_copy updated", "wait_before_copy": update.wait_before_copy}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.patch("/config/verify_delay")
def update_verify_delay(update: VerifyDelayUpdate):
    try: 
        autosort.config.set("verify_delay", update.verify_delay)  
    except Exception as e: 
        raise HTTPException(status_code=500, detail=str(e))
    
@app.patch("/config/merge_duplicates")
def update_merge_duplicates(update: ManageDuplicatesUpdate): 
    try: 
        autosort.config.set("merge_duplicates", update.merge_duplicates)
    except Exception as e: 
        raise HTTPException(status_code=500, detail=str(e))
    
    
    
app.get("")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
    
# .\venv\Scripts\activate.bat
# uvicorn main:app --reload --host 0.0.0.0 --port 8001