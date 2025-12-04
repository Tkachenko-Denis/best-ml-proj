# Ansible конфигурация для FireWatch.ai

Ansible playbook для настройки виртуальной машины, созданной с помощью Terraform.

## Что делает playbook

1. Устанавливает системные зависимости (python3, docker)
2. Устанавливает uv через pip
3. Создает пользователя ml-dev
4. Копирует requirements.txt и устанавливает Python пакеты
5. Настраивает FastAPI приложение как systemd сервис
6. Запускает приложение

## Предварительные требования

```bash
# Установка Ansible
pip install ansible

# Или через apt (Ubuntu/Debian)
sudo apt update
sudo apt install ansible
```

## Использование

### 1. Получить IP адрес ВМ из Terraform

```bash
cd ../terraform
terraform output vm_external_ip
```

### 2. Обновить inventory

Отредактируйте `inventory.ini` и замените IP на реальный из Terraform output:

```ini
[firewatch_servers]
firewatch-vm ansible_host=51.250.87.142 ansible_user=ubuntu
```

### 3. Проверить подключение

```bash
ansible all -m ping
```

### 4. Запустить playbook

```bash
ansible-playbook playbook.yml
```

### 5. Проверить статус сервиса

```bash
ansible firewatch_servers -m shell -a "systemctl status firewatch-api"
```

## Команды для управления

```bash
# Проверка синтаксиса
ansible-playbook playbook.yml --syntax-check

# Dry-run (без изменений)
ansible-playbook playbook.yml --check

# Запуск с verbose
ansible-playbook playbook.yml -v

# Запуск конкретных задач
ansible-playbook playbook.yml --tags "install"

# Выполнение ad-hoc команд
ansible firewatch_servers -m shell -a "docker ps"
ansible firewatch_servers -m shell -a "systemctl status firewatch-api"
```

## Структура

```
ansible/
├── playbook.yml              # Основной playbook
├── inventory.ini             # Список серверов
├── ansible.cfg               # Конфигурация Ansible
├── templates/
│   └── firewatch-api.service.j2  # Шаблон systemd сервиса
└── README.md
```

## Переменные

Основные переменные в `playbook.yml`:

- `ml_user: ml-dev` - имя пользователя для ML задач
- `python_version: "3.10"` - версия Python
- `app_dir: /opt/firewatch` - директория приложения

## Troubleshooting

### Ошибка подключения SSH
```bash
# Проверьте доступность хоста
ping 51.250.87.142

# Проверьте SSH ключ
ssh -i ~/.ssh/id_rsa ubuntu@51.250.87.142
```

### Ошибка прав доступа
```bash
# Убедитесь, что пользователь ubuntu имеет sudo права
ansible firewatch_servers -m shell -a "sudo whoami"
```

## Интеграция с Terraform

После `terraform apply` автоматически обновить inventory:

```bash
# Получить IP из Terraform и обновить inventory
EXTERNAL_IP=$(cd ../terraform && terraform output -raw vm_external_ip)
echo "VM IP: $EXTERNAL_IP"

# Обновить inventory вручную или запустить playbook напрямую
ansible-playbook -i "$EXTERNAL_IP," -u ubuntu playbook.yml
```
