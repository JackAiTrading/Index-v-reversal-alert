#!/usr/bin/env bash
# macOS / Linux：用 uv 重建页面数据（Windows 继续使用 refresh_live_data.bat）。
# 参数原样透传给 scripts/build_live_data.py；模型工程不在默认位置时需要指定，例如：
#   ./refresh_live_data.sh --model-root /path/to/V-Right
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if ! command -v uv >/dev/null 2>&1; then
  echo "[错误] 未找到 uv，请先安装：brew install uv" >&2
  exit 1
fi

uv run scripts/build_live_data.py --output-dir public/data "$@"
echo "[完成] live 数据已刷新。"
