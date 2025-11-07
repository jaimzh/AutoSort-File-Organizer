from .config_routes import router as config_router
from .scan_routes import router as scan_router

__all__ = ["config_router", "scan_router"]