@echo off
setlocal enabledelayedexpansion

:: 检查Python是否安装
py --version >nul 2>&1
if errorlevel 1 (
    echo Python not found. Please install Python 3.8+ and add it to PATH.
    pause
    exit /b 1
)

:: 检查pip是否安装
py -m pip --version >nul 2>&1
if errorlevel 1 (
    echo pip not found. Please install Python 3.8+ with pip and add it to PATH.
    pause
    exit /b 1
)

:: 创建虚拟环境
if not exist "venv" (
    echo Creating virtual environment...
    py -m venv venv
)

:: 激活虚拟环境
call venv\Scripts\activate.bat

:: 安装依赖
echo Installing dependencies...
pip install -r requirements.txt

:: 加载环境变量
if exist ".env" (
    echo Loading environment variables from .env...
    for /f "usebackq tokens=*" %%a in (".env") do (
        set "%%a"
    )
)

:: 启动后端服务
echo Starting backend service on port 8002...
start /B py backend.py

:: 等待后端启动
timeout /t 3 /nobreak >nul

:: 启动前端静态资源服务
echo Starting frontend static server on port 8001...
cd static
start /B py -m http.server 8001 --bind 127.0.0.1
cd ..

echo All services started!
echo Backend service: http://localhost:8002
echo Frontend static server: http://localhost:8001
echo Access the application at: http://localhost:8001

pause
