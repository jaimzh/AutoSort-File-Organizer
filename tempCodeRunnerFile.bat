@echo off

REM this is a batch script that will run or at least start the entire software both fe and be just by running it

:: Activate python env 
cd server\AutoSort-File-Organizer
call .\venv\Scripts\activate.bat


:: Start backend server
start cmd /k  uvicorn main:app --reload --host 0.0.0.0 --port 8001



:: Start frontend server
cd ..\..\client\autosort-file-organizer
flutter run windows