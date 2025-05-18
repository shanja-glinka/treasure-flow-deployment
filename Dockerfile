# Базовый образ
FROM node:20-alpine

# Создаем рабочую директорию
WORKDIR /app

# Устанавливаем PM2 и migrate-mongo
RUN npm install -g pm2 migrate-mongo

# Устанавливаем SSH доступ для клонирования
RUN apk add --no-cache git openssh

# Генерируем SSH ключи
RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Клонируем приложения
RUN git clone git@github.com:shanja-glinka/treasure-flow.git ./api && \
    git clone git@github.com:shanja-glinka/treasure-flow-file-storage.git ./file && \
    git clone git@github.com:shanja-glinka/treasure-flow-auctions.git ./auction

# Устанавливаем зависимости и собираем приложения
WORKDIR /app/api
COPY ./env/api.env .env
RUN npm ci && npm run build && migrate-mongo up

WORKDIR /app/file
COPY ./env/file.env .env
RUN npm ci && npm run build && migrate-mongo up

WORKDIR /app/auction
COPY ./env/auction.env .env
RUN npm ci && npm run build && migrate-mongo up

# Копируем PM2 конфиг
WORKDIR /app
COPY ./ecosystem.config.js ./ecosystem.config.js

# Открываем порты
EXPOSE 8141 8145 8146

# Запуск через PM2
CMD ["pm2-runtime", "start", "ecosystem.config.js"]
