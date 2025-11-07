from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
from autosort.core.autosort import AutoSort
from autosort.core.config import ConfigManager
from autosort.services.get_logs_and_counts import get_scan_logs, get_monitor_logs, get_lifetime_counts, read_logs_file, clear_logs, reset_lifetime_counts
from fastapi import HTTPException

from routes import config_router, scan_router, monitor_router, counts_router, logs_router
app = FastAPI(title="AutoSort API", version="1.0.0")

app.include_router(config_router)
app.include_router(scan_router)
app.include_router(monitor_router)
app.include_router(counts_router)
app.include_router(logs_router)
 
@app.get("/")
def read_root():
    return {"message": "alright so this is the autosort api"}

#just to check if api is connected or not
@app.get("/health")
def health():
    return {"status": "ok"}


# TODO: documentation for server



if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
    
# cd Autosort-File-Organizer
# .\venv\Scripts\activate.bat
# uvicorn main:app --reload --host 0.0.0.0 --port 8001