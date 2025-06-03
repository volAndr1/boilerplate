Вот обновлённая версия отчёта в формате **Markdown**, с добавленной прямой ссылкой на твой App Service:

---

## Задание: Деплой в Azure App Service через GitHub Actions

**Описание выполненного задания:**

### ✅ 1. Создание инфраструктуры в Azure

* В [портале Azure](https://portal.azure.com/) создана **Resource Group** с именем `My_Rg`.
* Внутри ресурсной группы создан **App Service** с именем [`my-web-app-labb-9`](https://portal.azure.com/#@andreyvoloshin111gmail.onmicrosoft.com/resource/subscriptions/f6acd7b4-cc8b-41de-8dd2-01d6bf26140f/resourceGroups/My_Rg/providers/Microsoft.Web/sites/my-web-app-labb-9/appServices):

  * Тип деплоя: *Docker контейнер* (опция "Deploy container instead of code").
  * План: **Free (F1)**.

### ✅ 2. Создание Azure Service Principal

* Открыт [Azure Cloud Shell (Bash)](https://shell.azure.com/bash).
* Выполнена команда:

  ```bash
  az ad sp create-for-rbac --name "myApp" --role contributor --scopes /subscriptions/<subscription_id>/resourceGroups/<resource_group_name> --json-auth
  ```
* Идентификатор подписки найден через [Subscriptions](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade).
* Получен JSON-ответ:

  ```json
  {
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>"
  }
  ```

### ✅ 3. Добавление секрета в GitHub

* В репозитории GitHub: **Settings → Secrets and variables → Actions**
* Добавлен новый секрет:

  * **Name:** `AZURE_CREDENTIALS`
  * **Value:** Весь JSON-ответ без пробелов и переносов строк.

### ✅ 4. Обновление GitHub workflow

Добавлены шаги в `workflow` для входа в Azure и деплоя в App Service:

```yaml
- name: Logging into Azure
  uses: azure/login@v2
  with:
    creds: ${{ secrets.AZURE_CREDENTIALS }}

- name: Deploy to Azure Web App
  uses: azure/webapps-deploy@v2
  with:
    app-name: my-web-app-labb-9
    images: ghcr.io/${{ github.actor }}/${{ github.event.repository.name }}:latest
```

### ✅ 5. Запуск workflow и проверка

* Workflow успешно завершился.
* В логах найден URL, начинающийся с `App Service Application Url`.
* При переходе по ссылке открывается развернутая фронтенд-страница из Docker-образа.
* [Проверка в портале Azure](https://portal.azure.com/#@andreyvoloshin111gmail.onmicrosoft.com/resource/subscriptions/f6acd7b4-cc8b-41de-8dd2-01d6bf26140f/resourceGroups/My_Rg/providers/Microsoft.Web/sites/my-web-app-labb-9/appServices) подтверждает, что приложение успешно работает.

---
