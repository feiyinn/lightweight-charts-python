@echo off
setlocal EnableDelayedExpansion

:: 定义颜色代码
set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "CYAN=[96m"
set "NC=[0m"

set "ERROR=%RED%[ERROR]%NC% "
set "INFO=%CYAN%[INFO]%NC% "
set "WARNING=%YELLOW%[WARNING]%NC% "

:: 删除旧的构建文件
if exist dist\bundle.js (
    del /Q dist\bundle.js
    if exist dist\typings rmdir /S /Q dist\typings
    echo %INFO%deleted bundle.js and typings..
) else (
    echo %WARNING%could not delete old dist files, continuing..
)

:: 运行 rollup 构建
call npx rollup -c rollup.config.js
if %ERRORLEVEL% neq 0 (
    echo %ERROR%Rollup build failed
    exit /b 1
)

:: 复制文件到 Python 包目录
if not exist lightweight_charts\js mkdir lightweight_charts\js
copy /Y dist\bundle.js lightweight_charts\js
copy /Y src\general\styles.css lightweight_charts\js

if %ERRORLEVEL% equ 0 (
    echo %INFO%copied bundle.js, style.css into python package
) else (
    echo %ERROR%could not copy dist into python package?
    exit /b 1
)

echo.
echo %GREEN%[BUILD SUCCESS]%NC%
exit /b 0 