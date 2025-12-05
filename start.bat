@echo off

title Computer Use Agent

echo.
echo ==============================================
echo Computer Use Agent Startup Script
echo ==============================================
echo.

REM Check Python installation
py --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python 3.8+
    echo Visit: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [OK] Python installed

REM Check pip
pip --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] pip not found. Check Python installation
    pause
    exit /b 1
)

echo [OK] pip installed

REM Load environment variables
if exist ".env" (
    echo [INFO] Loading environment variables...
    for /f "tokens=*" %%i in (.env) do set %%i
    echo [OK] Environment variables loaded
) else (
    echo [WARNING] .env file not found
)

echo.

REM Start backend service
echo [INFO] Starting backend service...
start /B py backend.py

REM Wait for backend to start
timeout /t 3 /nobreak >nul

REM Start frontend static file server
echo [INFO] Starting frontend static file server...
cd static
start /B py -m http.server 8001 --bind 127.0.0.1
cd ..


echo [OK] Services started!
echo [INFO] Access address: http://localhost:7860
echo.
echo [INFO] Press Ctrl+C to stop all services...

REM Wait for user input
pause

REM Stop all services
echo [INFO] Stopping services...
taskkill /IM python.exe /F 2>nul

echo [OK] All services stopped

echo [INFO] Installing dependencies...
call venv\Scripts\activate.bat
pip install -r requirements.txt

if errorlevel 1 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

echo [OK] Dependencies installed
echo.



echo [INFO] Starting application...
echo ==============================================
echo URL: http://localhost:7860
echo ==============================================
echo.
echo Press Ctrl+C to stop
echo.

py vibe_eval.py

if errorlevel 1 (
    echo.
    echo [ERROR] Application exited with error
    pause >nul
)
