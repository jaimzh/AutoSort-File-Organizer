from fastapi import APIRouter, HTTPException
from autosort_instance import autosort

router = APIRouter(prefix="/scan", tags=["Scan"])

@router.post("/scan/start")
def scan_folder():
    try:
        autosort.scan_now()
        return {"message": "Manual scan completed"}
    except Exception as e: 
        raise HTTPException(status_code=500, detail=f"Scan failed: {e}")
        
    
    

@router.post("/scan/stop")
def stop_scan():
    try:
        autosort.stop_scan()
        return {"message": "Scan stop requested"}
    except Exception as e: 
        raise HTTPException(status_code=500, detail=f"Stop failed: {e}")