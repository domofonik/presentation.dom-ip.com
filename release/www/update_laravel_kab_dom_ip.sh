#!/bin/bash

# Скрипт оновлення Laravel проекту
# Використовує PHP 8.4

set -e  # Зупинити виконання при помилці

# Змінна з шляхом до правильного PHP
PHP_BIN="/opt/alt/php84/usr/bin/php"

echo "Розпочинаю оновлення сайту..."

# Перехід в директорію проекту (ВИПРАВЛЕНО ШЛЯХ)
cd laravel-kab-dom-ip/my-portal || {
    echo "Помилка: не вдалося перейти в директорію проекту"
    exit 1
}

# Отримуємо останні зміни з remote
echo "Отримую зміни з GitHub..."
git fetch origin

# Скидаємо локальні зміни, щоб уникнути конфліктів (ДОДАНО)
echo "Скидаю локальні зміни..."
git reset --hard origin/main

# Встановлюємо залежності Composer (ВИКОРИСТОВУЄМО PHP 8.4)
echo "Встановлюю залежності Composer..."
$PHP_BIN ~/composer.phar install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Очищаємо та кешуємо конфігурацію Laravel (ВИКОРИСТОВУЄМО PHP 8.4)
echo "Оновлюю кеш Laravel..."
$PHP_BIN artisan config:clear
$PHP_BIN artisan cache:clear
$PHP_BIN artisan route:clear
$PHP_BIN artisan view:clear

$PHP_BIN artisan config:cache
$PHP_BIN artisan route:cache
$PHP_BIN artisan view:cache

# Запускаємо міграції
echo "Перевіряю міграції..."
$PHP_BIN artisan migrate --force



echo ""
echo "Оновлення успішно завершено!"