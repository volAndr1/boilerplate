## Завдання 1: Hello GitHub Actions & Publish Packages

Я виконав практичні завдання **"Hello GitHub Actions"** та **"Publish Packages"** на [GitHub Skills](https://skills.github.com/). Посилання на репозиторії:

* [Hello GitHub Actions](https://github.com/volandr1/github-actions)
* [Publish Packages](https://github.com/volandr1/publish-packages)

---

## Завдання 2: Створення власного GitHub Workflow

Я створив власний GitHub Workflow для збірки Docker-образу фронтенд-проєкту та завантаження його у GitHub Container Registry. Воркфлоу відповідає всім вимогам:

### ✅ Тригери:

* `workflow_dispatch` — ручний запуск
* `push` у гілки:

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

### ✅ Реалізовано:

* Репозиторій клоновано за допомогою `actions/checkout@v3`

* Установлення `pnpm`, інсталяція залежностей та збірка проєкту виконуються єдиним скриптом

* Авторизація у GitHub Container Registry реалізована через `GITHUB_TOKEN` та `github.actor`

* Docker-образ збирається та публікується з тегом:

  ```
  ghcr.io/volandr1/boilerplate:latest
  ```

* Образ успішно відображається у вкладці **Packages** у профілі GitHub

---
