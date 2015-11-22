@echo off
REM This is the Windows batch file version of this script for NT/XP and later.
REM
REM By Steven Saus
REM Licensed under a Creative Commons BY-SA 3.0 Unported license
REM To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/.
REM
REM SPLITTING AND WORKING WITH STRINGS REFERENCE
REM http://stackoverflow.com/questions/23600775/windows-batch-file-split-string-with-string-as-delimiter
REM http://www.dostips.com/forum/viewtopic.php?f=3&t=6429
REM http://stackoverflow.com/questions/7005951/batch-file-find-if-substring-is-in-string-not-in-a-file
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

@setlocal enableextensions enabledelayedexpansion

REM test if argument passed
if [%1] == [] (goto explain)

:testgrep
if EXIST %GREPEXE% (goto :testwget)
@echo.
@echo Grep not found in path.  Please ensure you have Grep installed correctly to use this script.
goto :end

:testwget
if EXIST %WGETEXE% (goto :testuget)
@echo.
@echo Wget not found in path.  Please ensure you have Wget installed correctly to use this script.
goto :end

:testuget
if EXIST %UGETEXE% (goto :main)
@echo.
@echo Uget not found in path.  Please ensure you have Uget installed correctly to use this script.
goto :end

:explain
@echo.
@echo You did not specify an URL. This won't work without one.
goto :end

:main
REM #########################################################################
REM # Using wget to get file info, writing to scratch file
REM #########################################################################
%WGETEXE% --spider %1 1> %temp%\wgettemp.txt 2>&1

REM #########################################################################
REM # Getting filename and ext as backup
REM #########################################################################
FOR /F "tokens=* USEBACKQ" %%F IN (`%GREPEXE% -i -m2 -e "^--" %temp%\wgettemp.txt `) DO (
SET scratch1=%%F
)
for /f "tokens=3" %%G IN ("%scratch1%") DO SET fileurl=%%G
for /F "tokens=4 delims=/" %%a in ("%fileurl%") DO SET filename=%%a
for /F "tokens=2 delims=." %%a in ("%filename%") DO SET fileext=%%a

REM #########################################################################
REM # Getting and parsing mimetype
REM #########################################################################
FOR /F "tokens=* USEBACKQ" %%F IN (`%GREPEXE% -i -m2 -e "^Length:" %temp%\wgettemp.txt `) DO (
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
if %submimetype% == octet.stream goto nameprocessing
REM http://stackoverflow.com/questions/21348579/check-if-label-exists-cmd
findstr /r /i /c:^:%mimetype% %0>nul
if errorlevel 1 goto nameprocessing
goto %mimetype%
goto end

REM #########################################################################
REM # This is where you set all your mimetype definitions
REM # Strictly speaking, you could get rid of everything except the ones that
REM # start with application, but I've left them all to show my work.
REM #########################################################################

REM ############################ HOME
start %UGETEXE% %2 %1 --category-index=0
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
:application/a-gzip
:application/x-gunzip
start %UGETEXE% %2 %1 --category-index=1
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
:application/epub+zip
:application/vnd.amazon.ebook
:application/x-mobipocket-ebook
start %UGETEXE% %2 %1 --category-index=2
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
start %UGETEXE% %2 %1 --category-index=3
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
start %UGETEXE% %2 %1 --category-index=4
goto end

REM ############################ PACKAGES
:packages
:application/x.debian.package
:application/x-redhat-package-manager 
:application/x-rpm
start %UGETEXE% %2 %1 --category-index=5
goto end

REM ############################ TORRENTS
:torrents
:application/x.bittorrent
start %UGETEXE% %2 %1 --category-index=6
goto end

REM ############################ ISOS
:isos
:application/x-cd-image
start %UGETEXE% %2 %1 --category-index=7
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
start %UGETEXE% %2 %1 --category-index=8
goto end

REM #########################################################################
REM # This is where the work of matching extensions will happen
REM # Please feel free to add whatever extensions you want to the filetype string
REM #########################################################################

:nameprocessing
SET archivefiletype="7z,zip,tar,gz,rar,arj"
SET documentfiletype="doc,docx,xls,xlsx,odt,odf,css,html,rtf,csv,tsv,pdf"
SET moviefiletype="avi,mov,m4v,mpg,mpeg"
SET musicfiletype="mp3,midi,mod,s3m,wav,ogg,m3u,pls"
SET packagefiletype="deb,rpm,yum,msi"
SET torrentfiletype="torrent,magnet"
SET isofiletype="iso,cue,"
SET imagefiletype="ico,tif,png,jpg,jpeg,bmp,svg,gif"

if not "x!archivefiletype:%fileext%=!"=="x%archivefiletype%"  goto archives
if not "x!documentfiletype:%fileext%=!"=="x%documentfiletype%"  goto documents
if not "x!moviefiletype:%fileext%=!"=="x%moviefiletype%"  goto movies
if not "x!musicfiletype:%fileext%=!"=="x%musicfiletype%"  goto music
if not "x!packagefiletype:%fileext%=!"=="x%packagefiletype%"  goto packages
if not "x!torrentfiletype:%fileext%=!"=="x%torrentfiletype%"  goto torrents
if not "x!isofiletype:%fileext%=!"=="x%isofiletype%"  goto isos
if not "x!imagefiletype:%fileext%=!"=="x%imgagefiletype%"  goto images
REM Everything else gets put in the default category
goto home

:end
REM Cleaning up
DEL %temp%\wgettemp.txt