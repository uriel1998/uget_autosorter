@echo off
REM This is the Windows batch file version of this script for NT/XP and later.
REM
REM By Steven Saus
REM Licensed under a Creative Commons BY-SA 3.0 Unported license
REM To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
REM
REM If you did not use the installer, you should edit this file and put the path to wget.exe in the line below!
set WGETEXE=c:\Progra~1\GnuWin32\bin\wget.exe
REM Windows port of WGet: http://gnuwin32.sourceforge.net/packages/wget.htm
REM
set GREPEXE=c:\Progra~1\GnuWin32\bin\egrep.exe
REM Windows port of WGet: http://gnuwin32.sourceforge.net/packages/grep.htm
REM Please remember that uGet must be installed properly!
REM Specify the path to java.exe on the line below.
set UGETEXE=c:\uGet\bin\uget.exe
REM
REM 
REM Revision history
REM 20121115_2115: uriel1998: Original code


REM SPLITTING STRINGS
REM http://stackoverflow.com/questions/23600775/windows-batch-file-split-string-with-string-as-delimiter
REM http://www.dostips.com/forum/viewtopic.php?f=3&t=6429


REM test if argument passed
if [%1] == [] (goto usage)
IF [%1]==[/w] (goto testjava)

:testgrep
if EXIST %GREPEXE% (goto :testwget)
@echo.
@echo Grep not found in path.  Please ensure you have Grep installed correctly to use this script.
goto :explain

:testwget
if EXIST %WGETEXE% (goto :testuget)
@echo.
@echo Wget not found in path.  Please ensure you have Wget installed correctly to use this script.
goto :explain

:testuget
if EXIST %UGETEXE% (goto :mimetype)
@echo.
@echo Uget not found in path.  Please ensure you have Uget installed correctly to use this script.
goto :explain



@ECHO OFF
REM #########################################################################
REM # Using wget to get file info, writing to scratch file
REM #########################################################################
wget --spider %1 1> %temp%\wgettemp.txt 2>&1

REM #########################################################################
REM # Getting filename and ext as backup
REM #########################################################################
FOR /F "tokens=* USEBACKQ" %%F IN (`egrep -i -m2 -e "^--" %temp%\wgettemp.txt `) DO (
SET scratch1=%%F
)
for /f "tokens=3" %%G IN ("%scratch1%") DO SET fileurl=%%G
for /F "tokens=4 delims=/" %%a in ("%fileurl%") DO SET filename=%%a
for /F "tokens=2 delims=." %%a in ("%filename%") DO SET fileext=%%a

REM #########################################################################
REM # Getting and parsing mimetype
REM #########################################################################
FOR /F "tokens=* USEBACKQ" %%F IN (`egrep -i -m2 -e "^Length:" %temp%\wgettemp.txt `) DO (
SET var=%%F
)
for /f "tokens=4" %%G IN ("%var%") DO SET tail=%%G 
SET tail=%tail:*[=%
SET mimetype=%tail:]=%
SET submimetype=%mimetype:*/=%
for /F "tokens=1 delims=/" %%a in ("%mimetype%") DO SET mainmimetype=%%a
if %mainmimetype% == audio goto music
if %mainmimetype% == text goto documents
if %mainmimetype% == video goto movies
if %mainmimetype% == image goto images
REM http://stackoverflow.com/questions/21348579/check-if-label-exists-cmd
findstr /r /i /c:^:%mimetype% %0>nul
if errorlevel 1 goto nameprocessing
REM Not strictly necessary any longer, but still.
if %submimetype% == octet.stream goto nameprocessing
goto %mimetype%
goto end

REM #########################################################################
REM # This is where you set all your definitions. 
REM #########################################################################

REM ############################ HOME

goto end

REM ############################ ARCHIVES
:archives
:application/zip
:application/arj
:application/x-bzip
:application/x-bzip2
:application/x-gtar
:application/x-compressed
:application/x-gzip
:application/lha
:application/x-lha
:application/x-tar
:application/gnutar
:application/x-compress

goto end
REM ############################ DOCUMENTS
:documents
:application/msword
:application/vnd.ms-powerpoint
:application/vnd.ms-excel
:text/css
:text/csv
:text/html
:text/javascript
:text/plain
:text/xml
:application/pdf
:application/vnd.oasis.opendocument.text
:application/vnd.oasis.opendocument.spreadsheet
:application/vnd.oasis.opendocument.presentation
:application/vnd.oasis.opendocument.graphics
:application/vnd.ms-excel
:application/vnd.ms-powerpoint
:application/msword
:application/vnd.ms-project
:application/mspowerpoint
:application/powerpoint
:application/x-mspowerpoint
:application/rtf
:application/x-rtf
:text/tab-separated-values
:application/mswrite
:application/x-wri
:application/excel
:application/x-excel
:application/x-msexcel
:application/vnd.ms-excel
:application/xml

goto end
REM ############################ MOVIES
:movies
:video/mpeg
:video/mp4
:video/ogg
:video/quicktime
:video/x-ms-wmv
:application/x-troff-msvideo
:video/avi
:video/msvideo
:video/x-msvideo

goto end
REM ############################ MUSIC
:music
:audio/x-wav
:audio/ogg
:audio/mpeg
:audio/vorbis
:audio/x-ms-wma
:audio/vnd.rn-realaudio
:audio/x-wav
:audio/x-mpequrl
:application/x-midi
:audio/midi
:audio/x-mpeg

goto end
REM ############################ PACKAGES
:packages
:application/x.debian.package

goto end
REM ############################ TORRENTS
:torrents
:application/x.bittorrent

goto end
REM ############################ ISOS
:isos
:application/x-cd-image

goto end
REM ############################ IMAGES
:images
:image/gif
:image/jpeg
:image/png
:image/svg+xml
:image/tiff
:image/bmp
:image/x-windows-bmp
:image/x-icon
:image/x-tiff

echo "woo"
goto end

REM #########################################################################
REM # This is where the laborious work of matching extensions will happen
REM # Please feel free to add whatever extensions you want
REM #########################################################################

:nameprocessing
if %fileext% == zip goto archives
if %fileext% == doc goto documents
if %fileext% == avi goto movies
if %fileext% == mp3 goto music
if %fileext% == deb goto packages
if %fileext% == torrent goto torrents
if %fileext% == iso goto isos
if %fileext% == png goto images
goto home

:end
