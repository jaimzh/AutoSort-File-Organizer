from fastapi import FastAPI
import uvicorn
from routes import (
    config_router,
    scan_router,
    monitor_router,
    counts_router,
    logs_router,
)


app = FastAPI(
    title="AutoSort API",
    version="1.0.0",
    description="Backend API for AutoSort — a smart file organization system.",
)

app.include_router(config_router)
app.include_router(scan_router)
app.include_router(monitor_router)
app.include_router(counts_router)
app.include_router(logs_router)


@app.get("/")
def read_root():
    return {"message": "Welcome to the AutoSort API"}

@app.get("/health")
def health():
    return {"status": "ok"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001, reload=True)







# TODO: documentation for server



# cd Autosort-File-Organizer
# .\venv\Scripts\activate.bat
# uvicorn main:app --reload --host 0.0.0.0 --port 8001
