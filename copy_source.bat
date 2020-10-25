
@echo off

rem usuwamy stare pliki
echo Usuwanie katalogow...
rmdir /S /Q .\Source\LBArchitect
rmdir /S /Q .\Source\Libs

rem kopiujemy nowe
echo Kopiowanie Builder...
xcopy .\Builder .\Source\LBArchitect\Builder\ /S /V /Y /I /Q /EXCLUDE:copy_source_ex.txt
if errorlevel 1 goto err
echo Kopiowanie Components...
xcopy .\Components .\Source\LBArchitect\Components\ /S /V /Y /I /Q /EXCLUDE:copy_source_ex.txt
if errorlevel 1 goto err
echo Kopiowanie Designer...
xcopy .\Designer .\Source\LBArchitect\Designer\ /S /V /Y /I /Q /EXCLUDE:copy_source_ex.txt
if errorlevel 1 goto err
echo Kopiowanie Factory...
xcopy .\Factory .\Source\LBArchitect\Factory\ /S /V /Y /I /Q /EXCLUDE:copy_source_ex.txt
if errorlevel 1 goto err
echo Kopiowanie Libs 1...
xcopy .\Libs .\Source\LBArchitect\Libs\ /S /V /Y /I /Q /EXCLUDE:copy_source_ex.txt
if errorlevel 1 goto err
echo Kopiowanie Release...
xcopy .\Release .\Source\LBArchitect\Release\ /S /V /Y /I /Q /EXCLUDE:copy_source_ex2.txt
if errorlevel 1 goto err
echo Kopiowanie Reaources...
xcopy .\resources .\Source\LBArchitect\resources\ /S /V /Y /I /Q
if errorlevel 1 goto err
echo Kopiowanie Libs 2...
xcopy ..\libs .\Source\Libs\ /S /V /Y /I /Q /EXCLUDE:copy_source_ex.txt
if errorlevel 1 goto err

echo OK!
pause
exit

:err
echo ERROR!!!
pause