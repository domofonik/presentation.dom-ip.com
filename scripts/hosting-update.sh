#!/usr/bin/env bash
set -euo pipefail

# Оновлення презентації на хостингу:
# 1) Git-репозиторій зберігається окремо від web-root
# 2) З репозиторію збирається локальний www-бандл
# 3) У web-root копіюється лише вміст www-бандла

REPO_URL="${REPO_URL:-https://github.com/domofonik/presentation.dom-ip.com.git}"
BRANCH="${BRANCH:-master}"

# Де зберігати службову копію репозиторію (окремо від сайту)
REPO_DIR="${REPO_DIR:-/opt/presentation.dom-ip.com/repo}"

# Кінцева директорія, яку обслуговує веб-сервер
WEB_ROOT="${WEB_ROOT:-/www/presentation.dom-ip.com}"

# Відносний шлях до скрипта збірки www-бандла
BUILD_SCRIPT_REL="${BUILD_SCRIPT_REL:-scripts/build-www.sh}"

echo "[INFO] Перевірка залежностей..."
command -v git >/dev/null 2>&1 || { echo "[ERROR] git не встановлено"; exit 1; }
command -v rsync >/dev/null 2>&1 || { echo "[ERROR] rsync не встановлено"; exit 1; }

echo "[INFO] Підготовка директорій..."
mkdir -p "$REPO_DIR"
mkdir -p "$WEB_ROOT"

if [ ! -d "$REPO_DIR/.git" ]; then
  echo "[INFO] Клонування репозиторію у $REPO_DIR"
  git clone --branch "$BRANCH" --single-branch "$REPO_URL" "$REPO_DIR"
else
  echo "[INFO] Оновлення репозиторію у $REPO_DIR"
  git -C "$REPO_DIR" fetch origin "$BRANCH"
  git -C "$REPO_DIR" checkout "$BRANCH"
  git -C "$REPO_DIR" reset --hard "origin/$BRANCH"
  git -C "$REPO_DIR" clean -fd
fi

BUILD_SCRIPT="$REPO_DIR/$BUILD_SCRIPT_REL"
if [ ! -f "$BUILD_SCRIPT" ]; then
  echo "[ERROR] Не знайдено build-скрипт: $BUILD_SCRIPT"
  exit 1
fi

echo "[INFO] Збірка www-бандла..."
bash "$BUILD_SCRIPT"

if [ ! -d "$REPO_DIR/www" ]; then
  echo "[ERROR] Не знайдено директорію бандла: $REPO_DIR/www"
  exit 1
fi

echo "[INFO] Синхронізація www-бандла у $WEB_ROOT"
rsync -av --delete \
  "$REPO_DIR/www/" "$WEB_ROOT/"

echo "[INFO] Деплой завершено успішно"
