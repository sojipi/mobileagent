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

REM Check .env file
if not exist ".env" (
    echo [ERROR] .env file not found
    pause
    exit /b 1
)

echo [OK] .env file found

echo.

echo [INFO] Installing dependencies...
pip install -r requirements.txt

if errorlevel 1 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

echo [OK] Dependencies installed
echo.



REM Start backend service
echo [INFO] Starting backend service...
start "Backend Service" /B "py" backend.py

REM Wait for backend to start
timeout /t 3 /nobreak >nul



REM Start frontend static resource service
echo [INFO] Starting frontend static resource service...
cd static
start "Frontend Service" /B "py" -m http.server 8001 --bind 127.0.0.1
cd ..

echo [INFO] Starting application...
echo ==============================================
echo URL: http://localhost:7860
echo ==============================================
echo.
echo Press Ctrl+C to stop
echo.

REM Wait for user to press Ctrl+C
:wait
ping -n 1 127.0.0.1 >nul
goto wait
