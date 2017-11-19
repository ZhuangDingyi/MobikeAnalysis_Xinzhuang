@echo off
:: 注意把要加的内容写在第7(即代码中more +7的那个数)行之下
for /f "delims=" %%i in ('dir/b *.json')do (
    echo %%i
    more +7 "%~0">>"%%i")

echo 处理完毕&ping -n 3 127.1>nul


]}