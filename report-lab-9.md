## Завдання: Деплой у Azure App Service через GitHub Actions

**Опис виконаного завдання:**

### ✅ 1. Створення інфраструктури в Azure

* У [порталі Azure](https://portal.azure.com/) створено **Resource Group** з назвою `My_Rg`.
* У межах ресурсної групи створено **App Service** з назвою [`my-web-app-labb-9`](https://portal.azure.com/#@andreyvoloshin111gmail.onmicrosoft.com/resource/subscriptions/f6acd7b4-cc8b-41de-8dd2-01d6bf26140f/resourceGroups/My_Rg/providers/Microsoft.Web/sites/my-web-app-labb-9/appServices):

  * Тип розгортання: *Docker контейнер* (опція "Deploy container instead of code").
  * Обрано план **Free (F1)**.

### ✅ 2. Створення Azure Service Principal

* Відкрито [Azure Cloud Shell (Bash)](https://shell.azure.com/bash).
* Виконано команду:

  ```bash
  az ad sp create-for-rbac --name "myApp" --role contributor --scopes /subscriptions/<subscription_id>/resourceGroups/<resource_group_name> --json-auth
  ```
* Ідентифікатор підписки знайдено у розділі [Subscriptions](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade).
* Отримано JSON-вивід:

  ```json
  {
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>"
  }
  ```

### ✅ 3. Додавання секрету в GitHub

* У репозиторії GitHub: **Settings → Secrets and variables → Actions**
* Додано новий секрет:

  * **Назва:** `AZURE_CREDENTIALS`
  * **Значення:** повний JSON-вивід без пробілів та перенесень рядків.

### ✅ 4. Оновлення GitHub workflow

У наявний workflow додано кроки для входу в Azure та деплою в App Service:

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

### ✅ 5. Запуск workflow та перевірка

* Workflow успішно завершився.
* У логах знайдено URL, що починається з `App Service Application Url`.
* Перехід за посиланням відкриває розгорнуту фронтенд-сторінку з Docker-образу.
* [Перевірка в Azure Portal](https://portal.azure.com/#@andreyvoloshin111gmail.onmicrosoft.com/resource/subscriptions/f6acd7b4-cc8b-41de-8dd2-01d6bf26140f/resourceGroups/My_Rg/providers/Microsoft.Web/sites/my-web-app-labb-9/appServices) підтверджує, що застосунок працює успішно.

---
