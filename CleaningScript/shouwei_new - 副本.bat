@echo off
for /r %%a in (*.json) do (
    (
	echo { "totalobjects":[
    type "%%~a"
    echo ]})>"%%~a.tmp"
    move "%%~a.tmp" "%%~a">nul
	echo %%a
)
pause