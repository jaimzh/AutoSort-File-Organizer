from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
from autosort.core.autosort import AutoSort
from autosort.core.config import ConfigManager
from autosort.services.get_logs_and_counts import get_scan_logs, get_monitor_logs, get_lifetime_counts, read_logs_file, clear_logs, reset_lifetime_counts
from fastapi import HTTPException

from routes import config_router, scan_router
app = FastAPI(title="AutoSort API", version="1.0.0")

app.include_router(config_router)
app.include_router(scan_router)
 
@app.get("/")
def read_root():
    return {"message": "alright so this is the autosort api"}

#just to check if api is connected or not
@app.get("/health")
def health():
    return {"status": "ok"}


    
   
    


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


@app.put("/counts/reset")
def reset_lifetime_counts_endpoint():
    """
    Reset the lifetime_counts.json file to default zeros.
    """
    try:
        new_counts = reset_lifetime_counts()
        return {"message": "✅ Lifetime counts reset successfully", "counts": new_counts}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))



app.get("")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
    
# cd Autosort-File-Organizer
# .\venv\Scripts\activate.bat
# uvicorn main:app --reload --host 0.0.0.0 --port 8001