@echo off
REM ============================================================================
REM Optimized File Renaming Batch Script
REM Recursively renames all files in the current directory and subdirectories,
REM replacing 'resonance', 'crystallization', and 'assimilation' with 'resonance',
REM 'crystallization', and 'assimilation' respectively in filenames.
REM ============================================================================

setlocal enabledelayedexpansion

echo File Renaming Script
echo Replaces 'resonance', 'crystallization', 'assimilation' with 'resonance', 'crystallization', 'assimilation'
echo.

REM Display current directory
echo This will rename files in: %CD%
echo This operation cannot be easily undone.
echo.

REM Ask for confirmation
set /p "confirm=Do you want to continue? (Y/N): "
if /i not "%confirm%"=="Y" if /i not "%confirm%"=="Yes" (
    echo Operation cancelled.
    goto :end
)

echo.
echo Starting file renaming process...
echo Please wait, this may take a while for large directories...
echo ============================================================================

REM Initialize counters
set "renamed_count=0"
set "error_count=0"
set "processed_count=0"

REM Create a temporary file list to avoid memory issues
set "temp_file=%temp%\filelist_%random%.txt"
echo Scanning files...
dir /b /s * > "%temp_file%" 2>nul

REM Process files from the temporary list
for /f "usebackq delims=" %%F in ("%temp_file%") do (
    set /a processed_count+=1
    
    REM Show progress every 100 files
    set /a "progress=!processed_count! %% 100"
    if !progress! equ 0 (
        echo Processed !processed_count! files...
    )
    
    call :process_file "%%F"
)

REM Clean up temporary file
if exist "%temp_file%" del "%temp_file%"

echo ============================================================================
echo Renaming process completed!
echo Files processed: !processed_count!
echo Files successfully renamed: !renamed_count!
echo Errors encountered: !error_count!

if !error_count! gtr 0 (
    echo.
    echo WARNING: Some errors occurred during renaming.
) else if !renamed_count! equ 0 (
    echo.
    echo No files needed to be renamed.
) else (
    echo.
    echo Success! !renamed_count! files were renamed.
)

goto :end

REM ============================================================================
REM Function to process a single file
REM ============================================================================
:process_file
set "filepath=%~1"

REM Skip if it's a directory
if exist "%filepath%\*" goto :eof

set "filename=%~nx1"
set "directory=%~dp1"
set "newname=%filename%"
set "changed=0"

REM Simple string replacement without complex functions
REM Replace resonance variations
if not "!newname!"=="!newname:resonance=resonance!" (
    set "newname=!newname:resonance=resonance!"
    set "changed=1"
)
if not "!newname!"=="!newname:Purity=Resonance!" (
    set "newname=!newname:Purity=Resonance!"
    set "changed=1"
)
if not "!newname!"=="!newname:PURITY=RESONANCE!" (
    set "newname=!newname:PURITY=RESONANCE!"
    set "changed=1"
)

REM Replace crystallization variations
if not "!newname!"=="!newname:crystallization=crystallization!" (
    set "newname=!newname:crystallization=crystallization!"
    set "changed=1"
)
if not "!newname!"=="!newname:Cloning=Crystallization!" (
    set "newname=!newname:Cloning=Crystallization!"
    set "changed=1"
)
if not "!newname!"=="!newname:CLONING=CRYSTALLIZATION!" (
    set "newname=!newname:CLONING=CRYSTALLIZATION!"
    set "changed=1"
)

REM Replace assimilation variations
if not "!newname!"=="!newname:assimilation=assimilation!" (
    set "newname=!newname:assimilation=assimilation!"
    set "changed=1"
)
if not "!newname!"=="!newname:Mutation=Assimilation!" (
    set "newname=!newname:Mutation=Assimilation!"
    set "changed=1"
)
if not "!newname!"=="!newname:MUTATION=ASSIMILATION!" (
    set "newname=!newname:MUTATION=ASSIMILATION!"
    set "changed=1"
)

REM If filename changed, rename the file
if "!changed!"=="1" (
    set "newpath=!directory!!newname!"
    
    REM Check if target file already exists
    if exist "!newpath!" (
        echo WARNING: Target exists - !newname!
        set /a error_count+=1
    ) else (
        REM Attempt to rename the file
        ren "!filepath!" "!newname!" 2>nul
        if !errorlevel! equ 0 (
            echo RENAMED: !filename! -^> !newname!
            set /a renamed_count+=1
        ) else (
            echo ERROR: Failed - !filename!
            set /a error_count+=1
        )
    )
)

goto :eof

REM ============================================================================
REM End of script
REM ============================================================================
:end
echo.
echo Press any key to exit...
pause >nul
exit /b 0