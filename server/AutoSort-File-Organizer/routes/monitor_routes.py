from fastapi import APIRouter, HTTPException
from autosort_instance import autosort

router = APIRouter(prefix="/monitor", tags=["Monitor"])

@router.post("/start")
def start_monitor():
    try: 
        autosort.start_monitor()
        return {"message": "Monitoring started"}
    except Exception as e: 
        raise HTTPException(status_code=500, detail=f"Failed to start monitoring: {e}" )
    

@router.post("/stop")
def stop_monitor():
    try:
        autosort.stop_monitor()
        return {"message": "Monitoring stopped"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to stop monitoring: {e}" )
    
