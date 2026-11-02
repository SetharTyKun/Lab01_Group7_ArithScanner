@echo off
setlocal enabledelayedexpansion
set PASS=0
set FAIL=0
if not exist tests\actual mkdir tests\actual
for %%f in (tests\inputs\*.txt) do (
  java -cp build Main "%%f" > "tests\actual\%%~nxf"
  fc /w "tests\expected\%%~nxf" "tests\actual\%%~nxf" >nul
  if errorlevel 1 (
    echo FAIL  %%~nxf
    set /a FAIL+=1
  ) else (
    echo PASS  %%~nxf
    set /a PASS+=1
  )
)
echo.
echo Passed: !PASS!   Failed: !FAIL!
