@echo off

echo Building Docker image 'cordova-android:latest'...

docker build -t cordova-android:latest -f %~dp0..\..\Dockerfile %~dp0..\..

echo.
echo Build finished.
pause