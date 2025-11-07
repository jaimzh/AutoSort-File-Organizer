from fastapi import APIRouter, HTTPException
from autosort.services.get_logs_and_counts import (
    get_lifetime_counts,
    reset_lifetime_counts,
)

router = APIRouter(prefix="/counts", tags=["Counts"])


@router.get("/")
def get_counts():
    try:
        return get_lifetime_counts()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get counts: {e}")


@router.put("/reset")
def reset_counts():
    try:
        new_counts = reset_lifetime_counts()
        return {"message": "Lifetime counts reset successfully", "counts": new_counts}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to reset counts: {e}")
