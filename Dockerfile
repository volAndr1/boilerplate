FROM nginx:stable-alpine

WORKDIR /app

# Копируем все файлы проекта в контейнер
COPY . .

# Копируем содержимое папки dist в директорию nginx для отдачи статики
RUN cp -r dist/* /usr/share/nginx/html/

EXPOSE 80
