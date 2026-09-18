@echo off
setlocal
cd /d "%~dp0"

echo ==========================================
echo   ACTUALIZAR REPOSITORIO GIT
echo ==========================================
echo.

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ERROR: Este archivo .bat no esta dentro de un repositorio Git.
    pause
    exit /b 1
)

for /f "delims=" %%b in ('git branch --show-current') do set "BRANCH=%%b"

if not defined BRANCH (
    echo ERROR: No se pudo detectar la rama actual.
    pause
    exit /b 1
)

echo Rama actual: %BRANCH%
echo.
echo Cambios detectados:
git status --short
echo.

git add -A

git diff --cached --quiet
if not errorlevel 1 (
    echo No hay cambios nuevos para subir.
    pause
    exit /b 0
)

set "MSG="
set /p MSG=Escribe el mensaje del commit: 

if not defined MSG set "MSG=chore: actualizar proyecto"

echo.
echo Creando commit...
git commit -m "%MSG%"
if errorlevel 1 (
    echo.
    echo ERROR: No se pudo crear el commit.
    pause
    exit /b 1
)

echo.
echo Subiendo cambios a origin/%BRANCH%...
git push -u origin "%BRANCH%"
if errorlevel 1 (
    echo.
    echo ERROR: No se pudieron subir los cambios.
    echo Revisa tu conexion, permisos o si necesitas hacer pull primero.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   ACTUALIZACION COMPLETADA
echo ==========================================
pause
endlocal
