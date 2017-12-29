@echo off 

REM Company network regularly sits behind a proxy 
REM IT equipment usually comes with pre=configured proxy settings
REM and it AUTOMATICALLY enables itself even when you disabled it!!
REM sometimes that creates more issues than it solves, e.g. sudden connection drop etc.

REM This script solves proxy setting automatically resurrection issue
REM Theoretically it should work with Windows XP onwards, but only tested on Windows 7
REM So, proceed with caution

REM tools used: JREPL.BAT 7.9
REM https://www.dostips.com/forum/viewtopic.php?f=3&t=6044
REM 
REM References:
REM https://blogs.msdn.microsoft.com/askie/2017/06/20/what-is-defaultconnectionsettings-key/
REM https://answers.microsoft.com/en-us/ie/forum/ie11-iewindows8_1/lan-connection-settings-keep-changing-back-to/76a0f5d2-167f-41fa-bf40-1461b8c01642?auth=1
REM https://superuser.com/a/964026


ECHO "YOU ARE ABOUT TO TURN OFF PROXY ..."

SET File_PATH=%CD%
SET EXPORT_PROXY_FILENAME="proxy_export.reg"
SET IMPORT_PROXY_FILENAME="proxy_import.reg"
SET REGKEY_NAME="HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections"

ECHO "EXPORTING EXISTING PROXY SETTING ..."
Reg export %REGKEY_NAME% %EXPORT_PROXY_FILENAME% /y

ECHO "TURN OFF PROXY ..."
type %EXPORT_PROXY_FILENAME% | JREPL.BAT "(.+=hex:)((.{2},){8}).{2},(.+)" "$1$201,$4" /INC "/DefaultConnectionSettings/i/+0" /O %IMPORT_PROXY_FILENAME%

ECHO "TAKING EFFECT ..."
Reg import %IMPORT_PROXY_FILENAME%

ECHO "CLEANING UP ..."
DEL %IMPORT_PROXY_FILENAME%
DEL %EXPORT_PROXY_FILENAME%