
SETLOCAL ENABLEEXTENSIONS


IF "%ROOTDIR%"=="" set ROOTDIR=c:
set CYGROOTDIR=%ROOTDIR%\cygwin64


REM
REM make sure c:\temp exists
REM

set A=c:\temp
for %%i in (%A%) do set ATTR=%%~ai
set DIRATTR=%ATTR:~0,1%
if /I "%DIRATTR%" NEQ "d" mkdir %A%

REM
REM Download Cygwin to c:\temp
REM

cscript fetchcygwin.vbs

REM 
REM Install required packages from Cygwin
REM

c:\temp\setup-x86_64 -R %CYGROOTDIR%  -g  -P  emacs,emacs-el,ctags,git,wget,curl,openssh,zip,unzip,subversion,dos2unix,gnupg,cvs,make,aspell,aspell-en

REM
REM Download and install dotfiles
REM

set A=%USERPROFILE%\projects
for %%i in (%A%) do set ATTR=%%~ai
set DIRATTR=%ATTR:~0,1%
if /I "%DIRATTR%" NEQ "d" mkdir %A%

set DF=%USERPROFILE%\projects\dotfiles
for %%i in (%DF%) do set ATTR=%%~ai
set DIRATTR=%ATTR:~0,1%
if /I "%DIRATTR%"=="d" goto RUNINSTALL

chdir %A%
%CYGROOTDIR%\bin\git.exe clone  https://github.com/m0smith/dotfiles.git

REM
REM Run the dotfiles install
REM

:RUNINSTALL
SET INSTALLSCRIPT=%DF%\install.sh
for /F "usebackq delims==" %%f in (`c:\temp\hams\cygwin64\bin\cygpath.exe %INSTALLSCRIPT%`) do set IS2=%%f

%CYGROOTDIR%\bin\chmod.exe +x %IS2%
%CYGROOTDIR%\bin\bash.exe -l -c %IS2%

REM http://stackoverflow.com/questions/138981/how-do-i-test-if-a-file-is-a-directory-in-a-batch-script
