# Terraform конфигурация для FireWatch.ai

Здесь Terraform конфиг для развертывания инфраструктуры проекта FireWatch.ai в Yandex.Cloud.

## Создаваемые ресурсы

- **VPC Network** - виртуальная сеть для изоляции ресурсов
- **Subnet** - подсеть в зоне ru-central1-a
- **Security Group** - правила файрвола (SSH, HTTP/HTTPS, FastAPI)
- **Object Storage Bucket** - хранилище для ML данных с версионированием
- **Compute Instance** - виртуальная машина Ubuntu 22.04 LTS (2 vCPU, 2 GB RAM)

## Предварительные требования

1. Установленный Terraform (>= 1.0)
2. Аккаунт в Yandex.Cloud
3. Настроенный yc CLI
4. SSH ключ для доступа к ВМ

## Установка Terraform

### Windows
```powershell
choco install terraform
```

### Linux/macOS
```bash
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

## Настройка Yandex.Cloud CLI

```bash
# Установка yc CLI
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

# Инициализация
yc init

# Получение OAuth токена
yc config list

# Получение ID образа Ubuntu 22.04
yc compute image list --folder-id standard-images | grep ubuntu-22-04

# Создание сервисного аккаунта для Object Storage
yc iam service-account create --name firewatch-storage
yc iam access-key create --service-account-name firewatch-storage
```

## Быстрый старт

### 1. Клонирование и подготовка

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

### 2. Заполнение переменных

Отредактируйте `terraform.tfvars` и укажите свои значения:

```hcl
yc_token  = "AQA...ваш-токен"
cloud_id  = "b1gv8qh7j3k2m9n4p5r6"
folder_id = "b1g3f8k9m2n7p4q1s5t8"
bucket_name = "firewatch-ml-data-2024-prod"
storage_access_key = "YCA..."
storage_secret_key = "YCM..."
```

### 3. Инициализация Terraform

```bash
terraform init
```

Эта команда:
- Скачивает провайдер Yandex.Cloud
- Инициализирует backend
- Подготавливает рабочую директорию

### 4. Проверка плана

```bash
terraform plan
```

Terraform покажет, какие ресурсы будут созданы. Проверьте вывод перед применением.

### 5. Применение конфигурации

```bash
terraform apply
```

Введите `yes` для подтверждения. Процесс займет 2-3 минуты.

### 6. Получение выходных данных

После успешного создания вы увидите:

```
Outputs:

api_endpoint = "http://51.250.87.142:8000"
ssh_connection_string = "ssh ubuntu@51.250.87.142"
vm_external_ip = "51.250.87.142"
vm_id = "fhmq8r7s3t9v2w5x1y4z"
bucket_name = "firewatch-ml-data-2024-prod"
```

### 7. Подключение к ВМ

```bash
ssh ubuntu@<vm_external_ip>
```

### 8. Проверка в веб-консоли

Откройте [Yandex.Cloud Console](https://console.cloud.yandex.ru/) и проверьте созданные ресурсы:
- Compute Cloud → Виртуальные машины
- VPC → Сети
- Object Storage → Бакеты

### 9. Удаление ресурсов

**ВАЖНО:** Обязательно удалите ресурсы после тестирования, чтобы не платить за них:

```bash
terraform destroy
```

Введите `yes` для подтверждения.

## Структура файлов

```
terraform/
├── main.tf              # Основные ресурсы (VPC, VM, Storage)
├── variables.tf         # Определение переменных
├── outputs.tf           # Выходные значения
├── terraform.tfvars     # Значения переменных (не коммитить!)
├── terraform.tfvars.example  # Пример конфигурации
├── cloud-init.yaml      # Скрипт инициализации ВМ
└── README.md            # Эта инструкция
```

## Переменные

| Переменная | Описание | Значение по умолчанию |
|------------|----------|----------------------|
| `yc_token` | OAuth токен Yandex.Cloud | - |
| `cloud_id` | ID облака | - |
| `folder_id` | ID каталога | - |
| `zone` | Зона доступности | ru-central1-a |
| `vm_cores` | Количество vCPU | 2 |
| `vm_memory` | Объем RAM (GB) | 2 |
| `disk_size` | Размер диска (GB) | 20 |
| `preemptible` | Прерываемая ВМ (дешевле) | false |
| `environment` | Окружение (dev/prod) | dev |

## Outputs

После `terraform apply` доступны следующие выходные значения:

- `vm_external_ip` - публичный IP адрес ВМ
- `vm_internal_ip` - внутренний IP адрес
- `ssh_connection_string` - команда для SSH подключения
- `api_endpoint` - URL для FastAPI приложения
- `bucket_name` - имя созданного бакета
- `network_id`, `subnet_id`, `security_group_id` - ID сетевых ресурсов

## Полезные команды

```bash
# Показать текущее состояние
terraform show

# Показать выходные значения
terraform output

# Показать конкретное значение
terraform output vm_external_ip

# Форматирование кода
terraform fmt

# Валидация конфигурации
terraform validate

# Обновление провайдеров
terraform init -upgrade

# Импорт существующего ресурса
terraform import yandex_compute_instance.firewatch_vm fhmq8r7s3t9v2w5x1y4z
```