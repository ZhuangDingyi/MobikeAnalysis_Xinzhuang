@echo off
:: ע���Ҫ�ӵ�����д�ڵ�7(��������more +7���Ǹ���)��֮��
for /f "delims=" %%i in ('dir/b *.json')do (
    echo %%i
    more +7 "%~0">>"%%i")

echo �������&ping -n 3 127.1>nul


]}