Вот стилизованный отчет в формате **Markdown**, оформленный по примеру:

---

## Задание 1: Hello GitHub Actions & Publish Packages


Я завершил практические задания **"Hello GitHub Actions"** и **"Publish Packages"** на GitHub Skills.
Ссылки на репозитории:

* [Hello GitHub Actions](https://github.com/volandr1/github-actions)
* [Publish Packages](https://github.com/volandr1/publish-packages)

---

## Задание 2: Создание собственного GitHub Workflow



Я создал собственный GitHub Workflow для сборки Docker-образа фронтенд-проекта и загрузки его в GitHub Container Registry. Воркфлоу соответствует следующим требованиям:

### ✅ Триггеры:

* `workflow_dispatch` (ручной запуск)
* `push` в ветки:

  * `main`
  * `feature/**`

### ✅ Структура workflow:

```yaml
name: Checker

on:
  push:
    branches:
      - main
      - 'feature/**'
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Install pnpm and build project
        run: |
          npm install -g pnpm
          pnpm install
          pnpm run build

      - name: Log in to GitHub CR
        run: echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u ${{ github.actor }} --password-stdin

      - name: Docker image build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.actor }}/boilerplate:latest
```

### ✅ Что реализовано:

* Репозиторий клонируется с помощью `actions/checkout@v3`
* Установка `pnpm` и сборка проекта выполняются одной командой-скриптом
* Авторизация в GitHub Container Registry производится с использованием `GITHUB_TOKEN` и `github.actor`
* Docker-образ собирается и публикуется с тегом:

  ```
  ghcr.io/volandr1/boilerplate:latest
  ```
* Образ успешно отображается на вкладке [Packages](https://github.com/users/volandr1/packages)

---
