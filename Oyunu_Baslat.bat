@echo off
setlocal enabledelayedexpansion
title The Legend of Zelda: Ocarina of Time Remake - All-in-One Launcher
cd /d "%~dp0"

echo ===============================================================================
echo      THE LEGEND OF ZELDA: OCARINA OF TIME REMAKE - ALL-IN-ONE LAUNCHER
echo                 X: @lordumelkor
echo ===============================================================================
echo.

:: 1. Emülatör Kontrolü
if not exist "%~dp0Emulator\lichii.exe" (
    echo [HATA / ERROR]
    echo.
    echo [TR] "Emulator\lichii.exe" bulunamadi!
    echo Lutfen GitHub Release sayfasindan tam "Zelda-OoT-Remake-AllinOne-v1.0.zip" paketini
    echo indirdiginizden ve tum dosyalari ayni klasore cikardiginizdan emin olun.
    echo.
    echo [EN] "Emulator\lichii.exe" was not found!
    echo Please make sure you downloaded the complete "Zelda-OoT-Remake-AllinOne-v1.0.zip"
    echo package from the GitHub Release page and extracted all files together.
    echo.
    pause
    exit /b
)

:: 2. ROM Dosyasi Kontrolu
set "ROM_FILE="
for %%F in ("ROM_BURAYA_KONACAK\*.nup") do (
    set "ROM_FILE=%%~fF"
    goto :RomFound
)
for %%F in ("*.nup") do (
    set "ROM_FILE=%%~fF"
    goto :RomFound
)

:RomNotFound
echo [UYARI / WARNING]
echo.
echo [TR] ROM dosyasi bulunamadi!
echo Lutfen .nup uzantili oyun ROM'unuzu "ROM_BURAYA_KONACAK" klasorune kopyalayin
echo ve bu baslaticiyi tekrar calistirin.
echo.
echo [EN] ROM file not found!
echo Please place your .nup game ROM inside the "ROM_BURAYA_KONACAK" folder
echo and restart this launcher.
echo.
echo "ROM_BURAYA_KONACAK" klasoru aciliyor...
explorer "%~dp0ROM_BURAYA_KONACAK"
echo.
pause
exit /b

:RomFound
echo [1/3] ROM tespit edildi: "!ROM_FILE!"
echo.

:: 3. 30.000 Shader Cache Acilisi
if exist "%~dp0Emulator\user\cache\shader\0400486024dec000\vulkan-frizti.fork-v54.bin" goto :ShaderReady

echo [2/3] 30.000 Shader Cache paketi (v54) aciliyor...
echo Lutfen bekleyin, bu islem yuksek performans icin SADECE ilk acilista yapilir...

if not exist "%~dp0Emulator\user\cache\shader" mkdir "%~dp0Emulator\user\cache\shader" >nul 2>&1

if exist "%~dp0ShaderCache\shader_cache.part1" (
    copy /b "%~dp0ShaderCache\shader_cache.part1" + "%~dp0ShaderCache\shader_cache.part2" "%~dp0ShaderCache\temp_cache.tar.xz" >nul
    tar -xf "%~dp0ShaderCache\temp_cache.tar.xz" -C "%~dp0Emulator\user\cache\shader"
    del "%~dp0ShaderCache\temp_cache.tar.xz" >nul 2>&1
    echo [OK] 30.000 Shader derleme paketi basariyla kuruldu!
) else (
    echo [BILGI / INFO] ShaderCache arsivi bulunamadi, mevcut onbellek kullanilacak.
)
echo.
goto :ShaderDone

:ShaderReady
echo [2/3] Shader Cache paketi hazir - 30.000 Shader yuklu.
echo.

:ShaderDone

:: 4. Lossless Scaling Entegrasyonu
set "LS_STARTED_BY_US=0"
if not exist "%~dp0LosslessScaling\LosslessScaling.exe" (
    echo [BILGI / INFO] Lossless Scaling klasoru bulunamadi, emulatorden devam ediliyor...
    goto :SkipLossless
)

echo [3/3] Lossless Scaling ayari yapilandiriliyor...
if exist "%~dp0setup_helper.ps1" (
    powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0setup_helper.ps1" -LichiiPath "%~dp0Emulator\lichii.exe"
)

tasklist /FI "IMAGENAME eq LosslessScaling.exe" 2>NUL | find /I /N "LosslessScaling.exe" >NUL
if errorlevel 1 (
    start "" "%~dp0LosslessScaling\LosslessScaling.exe"
    set "LS_STARTED_BY_US=1"
    ping 127.0.0.1 -n 3 >nul
)

:SkipLossless

:: 5. Oyunu Baslat
echo.
echo ===============================================================================
echo  Oyun baslatiliyor! 
echo  Lossless Scaling LSFG 2X FPS / 0 Ghosting - 3 sn icinde otomatik devreye girecektir.
echo.
echo  Iyi oyunlar dileriz! / Have fun!
echo  X: @lordumelkor
echo ===============================================================================
echo.

start /wait "" "%~dp0Emulator\lichii.exe" "!ROM_FILE!"

:: 6. Oyun kapandiktan sonra Lossless Scaling'i kapat
if "!LS_STARTED_BY_US!"=="1" (
    echo.
    echo [BILGI / INFO] Oyun kapandi. Lossless Scaling kapatiliyor...
    taskkill /F /IM LosslessScaling.exe >nul 2>&1
    echo [OK] Lossless Scaling kapatildi.
)

exit /b
