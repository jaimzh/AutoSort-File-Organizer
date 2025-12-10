@echo off
REM Starts backend server for AutoSort File Organizer

:: Save repo root
set REPO_DIR=%~dp0

:: Start backend server in a new window
cd "%REPO_DIR%server\AutoSort-File-Organizer"
call .\venv\Scripts\activate.bat
start cmd /k "uvicorn main:app --reload --host 0.0.0.0 --port 8001"


:: Just a little frontend reminder
echo.
echo =========================================================
echo To run the frontend:
echo   1. Open the Flutter project in your IDE.
echo   2. Press F5 to start in debug mode with full IDE support.
echo =========================================================