#!/usr/bin/env bash
set -euo pipefail

# Збирає чисту директорію www/ з файлами, які дозволено публікувати.
# Запускається локально або на сервері перед деплоєм.

PROJECT_ROOT="${PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
OUTPUT_DIR="${OUTPUT_DIR:-$PROJECT_ROOT/www}"
INCLUDE_FILE="${INCLUDE_FILE:-$PROJECT_ROOT/deploy/www.include}"

echo "[INFO] Підготовка www-бандла у $OUTPUT_DIR"
command -v rsync >/dev/null 2>&1 || { echo "[ERROR] rsync не встановлено"; exit 1; }

if [ ! -f "$INCLUDE_FILE" ]; then
  echo "[ERROR] Не знайдено include-файл: $INCLUDE_FILE"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

rsync -av --delete \
  --filter="merge $INCLUDE_FILE" \
  "$PROJECT_ROOT/" "$OUTPUT_DIR/"

echo "[INFO] www-бандл оновлено успішно"
