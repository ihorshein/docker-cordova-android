@echo off

for %%i in ("%cd%") do set CONTAINER_NAME=%%~ni

echo Starting Cordova Android builder container named '%CONTAINER_NAME%'...
echo Your current directory will be mounted to /app inside the container.
echo.

docker run -it --rm --name %CONTAINER_NAME% -v "%cd%:/app" cordova-android