# Этап сборки с node 18
FROM node:18-alpine AS build
WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm
RUN pnpm install

COPY . .
RUN pnpm run build

# Этап nginx для отдачи статики
FROM nginx:1.24-alpine
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
