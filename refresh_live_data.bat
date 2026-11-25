@echo off
chcp 65001 >nul
cd /d "%~dp0"
where uv >nul 2>&1
if errorlevel 1 (
  echo [错误] 未找到 uv，请先安装：https://docs.astral.sh/uv/getting-started/
  pause
  exit /b 1
)
uv run scripts\build_live_data.py --model-root D:\V-Right --output-dir public\data
if errorlevel 1 (
  echo [错误] 数据生成失败。
  pause
  exit /b 1
)
echo [完成] live 数据已刷新。
pause
