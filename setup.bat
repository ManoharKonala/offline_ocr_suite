@echo off
REM Setup script for Windows - Offline OCR Suite

echo ===============================================
echo  Offline OCR Suite - Setup Script
echo ===============================================
echo.

REM Check if virtual environment exists
if exist "venv\Scripts\activate.bat" (
    echo Virtual environment already exists.
) else (
    echo Creating virtual environment...
    python -m venv venv
    if errorlevel 1 (
        echo ERROR: Failed to create virtual environment.
        echo Make sure Python is installed and in PATH.
        pause
        exit /b 1
    )
    echo Virtual environment created successfully.
)

echo.
echo Activating virtual environment...
call venv\Scripts\activate.bat

echo.
echo Installing dependencies...
pip install --upgrade pip
pip install -r requirements.txt

if errorlevel 1 (
    echo.
    echo ERROR: Failed to install dependencies.
    pause
    exit /b 1
)

echo.
echo ===============================================
echo  Setup Complete!
echo ===============================================
echo.
echo Next steps:
echo 1. Install Tesseract OCR from:
echo    https://github.com/UB-Mannheim/tesseract/wiki
echo.
echo 2. Add Tesseract to PATH or update config.yaml
echo.
echo 3. Run the GUI: python ocr_gui.py
echo    Or CLI: python ocr_cli.py --help
echo.
echo ===============================================

pause
