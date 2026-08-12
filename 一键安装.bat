@echo off
chcp 65001 >nul
title ComfyUI H3 一键安装
cd /d %~dp0
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0installer\install.ps1" %*
pause
