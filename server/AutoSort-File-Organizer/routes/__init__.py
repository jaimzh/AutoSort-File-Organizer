from .config_routes import router as config_router
from .scan_routes import router as scan_router
from .monitor_routes import router as monitor_router

__all__ = ["config_router", "scan_router", "monitor_router"]