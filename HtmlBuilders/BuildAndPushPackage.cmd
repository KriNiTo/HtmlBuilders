@echo off
set thisScriptFilename=%~n0%~x0

rem -- check if current dir is correct
if not exist %thisScriptFilename% echo "Please call from project-folder as current dir!"
if not exist %thisScriptFilename% goto ende

set releaseFolder=.\bin\Release\

rem -- remove old packages if any
if exist "%releaseFolder%*.nupkg" del %releaseFolder%*.nupkg



msbuild /p:Configuration=Release /t:Rebuild
IF NOT %ERRORLEVEL%==0 GOTO ende

msbuild /p:Configuration=Release /t:BuildPackage
IF NOT %ERRORLEVEL%==0 GOTO ende


rem -- remove source-packages if any
if exist "%releaseFolder%*symbols.nupkg" del "%releaseFolder%*symbols.nupkg"

rem -- find and set filename for new package
FOR %%f in ("%releaseFolder%*.nupkg") DO set package=%%f

rem -- push to nuget.org 
rem -- use ..\.nuget\NuGet.exe setApiKey <YourKey> if you push it for first time
..\.nuget\nuget push "%package%"
IF NOT %ERRORLEVEL%==0 GOTO ende


:ende
