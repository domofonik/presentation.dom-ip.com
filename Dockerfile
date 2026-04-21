FROM nginx:1.27-alpine

# Видаляємо дефолтну конфігурацію та контент
RUN rm -rf /usr/share/nginx/html/* /etc/nginx/conf.d/*

# Копіюємо презентацію, фото, фавікон та OG-зображення
COPY index.html /usr/share/nginx/html/index.html
COPY foto/ /usr/share/nginx/html/foto/
COPY favicon.ico /usr/share/nginx/html/favicon.ico
COPY og-image.png /usr/share/nginx/html/og-image.png

# Копіюємо конфігурацію nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Директорія для логів (монтується як volume)
RUN mkdir -p /var/log/nginx

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1
