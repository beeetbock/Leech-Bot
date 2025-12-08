@echo off
REM ========================================
REM KPSML-X Bot Smart Launcher for Windows
REM ========================================

REM Check if Docker is running
docker info >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Docker Desktop is not running.
    echo Please start Docker Desktop and try again.
    pause
    exit /b
)

REM Navigate to the folder containing this batch file
cd /d %~dp0

REM Build Docker image if not exists or force rebuild
echo.
echo Checking/building Docker image for KPSML-X...
docker image inspect kpsmlx >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Image not found. Building now...
    docker build -t kpsmlx .
) ELSE (
    echo Image already exists. Skipping build...
)

REM Optional: Uncomment the next line to always rebuild image
REM docker build -t kpsmlx .

REM Stop any running container with the same name
echo.
echo Stopping any existing container...
docker ps -q --filter "name=kpsmlx-container" | findstr . >nul
IF %ERRORLEVEL% EQU 0 (
    docker stop kpsmlx-container
    docker rm kpsmlx-container
)

REM Run the container
echo.
echo Starting KPSML-X bot...
docker run -d --name kpsmlx-container -p 80:80 -p 8080:8080 kpsmlx

echo.
echo Bot should now be running!
echo WebUI: http://localhost:80
echo Aria2 RPC (if enabled): http://localhost:8080
pause
