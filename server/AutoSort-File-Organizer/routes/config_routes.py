from fastapi import APIRouter, HTTPException
from typing import Any


from autosort_instance import autosort
from models.config_models import ( 
    ConfigUpdate,
    FullConfigUpdate,
    ExceptionsUpdate,
    RulesUpdate,
    RuleCategory,
    WaitBeforeCopyUpdate,
    VerifyDelayUpdate,
    ManageDuplicatesUpdate,
)

router = APIRouter(prefix="/config", tags=["Config"])

@router.get("/")
def get_config():
    return autosort.config._config

@router.put("/full_update")
async def full_update_config(update: FullConfigUpdate): 
    try: 
        autosort.config._config.clear()
        autosort.config._config.update(update.config)
        for key, value in update.config.items():
            autosort.config.set(key, value)

        return {
            "message": "Full configuration updated successfully",
            "config": autosort.config._config
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.put("/reset_defaults")
async def reset_config_to_defaults():
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
        autosort.config._config.clear()
        autosort.config._config.update(default_config)
        for key, value in default_config.items():
            autosort.config.set(key, value)
        return {
            "message": "Config reset to defaults successfully",
            "config": autosort.config._config,
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    

@router.patch("/update")
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


@router.get("/exceptions")
async def get_exceptions():
    try:
        exceptions = autosort.config.get("exceptions") or []
        return {
            "message": "Config Exceptions fetched successfully",
            "exceptions": exceptions
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

  
@router.patch("/exceptions")
async def update_exceptions(update: ExceptionsUpdate):
    try:
        autosort.config.set("exceptions", update.exceptions)

        return {
            "message": "Confing Exceptions updated successfully",
            "exceptions": autosort.config.get("exceptions")
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
           
        
@router.patch("/rules")
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


@router.patch("/rules/delete_category")
async def update_rules(update: RuleCategory):
    try:
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
    except Exception as e: 
        raise HTTPException(status_code=500, detail=str(e))
    
    
@router.get("/dark_mode")
def get_dark_mode():
    try:
        value = autosort.config.get("dark_mode", False)
        return {"dark_mode": value}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.patch("/dark_mode")
def update_dark_mode(value: bool):
    try:
        autosort.config.set("dark_mode", value)
        return {"message": "Dark mode updated", "dark_mode": value}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.patch("/wait_before_copy")
def get_wait_before_copy(update: WaitBeforeCopyUpdate):
    try: 
        autosort.config.set("wait_before_copy", update.wait_before_copy)
        return {"message": "wait_before_copy updated", "wait_before_copy": update.wait_before_copy}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.patch("/verify_delay")
def update_verify_delay(update: VerifyDelayUpdate):
    try: 
        autosort.config.set("verify_delay", update.verify_delay)  
    except Exception as e: 
        raise HTTPException(status_code=500, detail=str(e))
    
@router.patch("/merge_duplicates")
def update_merge_duplicates(update: ManageDuplicatesUpdate): 
    try: 
        autosort.config.set("merge_duplicates", update.merge_duplicates)
    except Exception as e: 
        raise HTTPException(status_code=500, detail=str(e))
    
    