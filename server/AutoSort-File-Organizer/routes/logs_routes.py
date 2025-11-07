from fastapi import APIRouter, HTTPException
from autosort.services.get_logs_and_counts import read_logs_file, clear_logs

router = APIRouter(prefix="/logs", tags=["Logs"])


@router.get("/")
def get_logs():
    
    try:
        return {"logs": read_logs_file()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to read logs: {e}")


@router.delete("/clear")
def clear_logs_endpoint():
    """
    Clear logs and session counts.
    """
    try:
        clear_logs()
        return {"message": "Logs and session counts cleared"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to clear logs: {e}")