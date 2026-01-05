@echo off
echo ========================================
echo  Compilando APK de SomosSalud
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] Limpiando proyecto...
call flutter clean
echo.

echo [2/3] Obteniendo dependencias...
call flutter pub get
echo.

echo [3/3] Compilando APK (esto puede tardar varios minutos)...
echo Por favor espera...
call flutter build apk --release
echo.

if %ERRORLEVEL% EQU 0 (
    echo ========================================
    echo  APK GENERADO EXITOSAMENTE!
    echo ========================================
    echo.
    echo El APK se encuentra en:
    echo build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo Tamaño aproximado: ~20-30 MB
    echo.
    pause
) else (
    echo ========================================
    echo  ERROR AL GENERAR APK
    echo ========================================
    echo.
    echo Verifica que:
    echo 1. Tengas Flutter instalado correctamente
    echo 2. Tengas conexion a internet
    echo 3. No haya errores en el codigo
    echo.
    pause
)
