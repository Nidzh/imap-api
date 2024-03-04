# Базовый образ
FROM node:14-alpine
# Установка supervisord
RUN apk add --no-cache supervisor
# Установка Redis
RUN apk add --update redis
# Создание директории приложения
WORKDIR /usr/src/app
# Установка зависимостей приложения
COPY src/package*.json ./
RUN npm install

# Копирование исходного кода приложения
COPY . .

# Настройка Supervisord
COPY supervisord.conf /etc/supervisord.conf

# Открытие порта приложения
EXPOSE 3000

# Запуск supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
