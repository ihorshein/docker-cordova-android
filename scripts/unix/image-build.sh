#!/bin/bash

echo "Building Docker image 'cordova-android:latest'..."

# Указываем путь к Dockerfile (-f) и путь к корневому каталогу проекта (контекст сборки)
docker build -t cordova-android:latest -f "$(dirname "$0")/../../Dockerfile" "$(dirname "$0")/../.."

echo ""
echo "Build finished."