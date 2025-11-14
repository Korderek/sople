@echo off
setlocal

rem === CONFIGURATION ===
set GAME_NAME=game
set LOVE_JS_PATH=love.js
set OUTPUT_DIR=web
set EXCLUDE_LIST=build-exclude.txt

rem === STEP 1: Create game.love ===
echo.
echo [1/3] Packing game into %GAME_NAME%.love...

rem Use 7-Zip to create the archive
rem Ensure exclude.txt lists files/folders to skip, one per line
if not exist "%EXCLUDE_LIST%" (
    echo No exclude.txt found, creating empty one...
    echo. > "%EXCLUDE_LIST%"
)

7z a -tzip "%GAME_NAME%.love" * -x@%EXCLUDE_LIST%
if errorlevel 1 (
    echo Error: Failed to create .love file
    exit /b 1
)

echo Done: %GAME_NAME%.love created.

rem === STEP 2: Build for Web using love.js ===
echo.
echo [2/3] Building web version with love.js...

rem Delete old build
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"

CALL npx love.js.cmd "%GAME_NAME%.love" "%OUTPUT_DIR%" -t "Polowace" -c
if errorlevel 1 (
    echo Error: love.js build failed
    exit /b 1
)
echo Done: Web build generated in %OUTPUT_DIR%.

rem === STEP 3: Pack web build into ZIP ===
echo.
echo [3/3] Creating web_build.zip for itch.io upload...

7z a -tzip "%OUTPUT_DIR%.zip" "%OUTPUT_DIR%\*"

if errorlevel 1 (
    echo Error: Failed to create web build zip
    exit /b 1
)

echo [4/4] Cleaning up...
if exist "%GAME_NAME%.love" del "%GAME_NAME%.love"
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"

echo Done: %OUTPUT_DIR%.zip ready for itch.io!

endlocal
