# Домашнее задание по теме 8: Конфигурация среды

## Описание

Автоматизированное развертывание FastAPI приложения с использованием Ansible ролей.

## Задачи

### Часть 1: Роль docker

Роль устанавливает и настраивает Docker на целевом сервере.

**Выполненные задачи:**
1. ✅ Установка зависимостей для репозитория Docker (apt-transport-https, ca-certificates, curl, gnupg, lsb-release)
2. ✅ Добавление GPG ключа репозитория Docker
3. ✅ Добавление официального репозитория Docker
4. ✅ Установка пакетов Docker (docker-ce, docker-ce-cli, containerd.io)
5. ✅ Установка Python библиотеки docker через pip
6. ✅ Запуск и добавление в автозагрузку службы Docker

**Файл:** `ansible-fastapi-hw/roles/docker/tasks/main.yml`

### Часть 2: Роль fastapi_app

Роль развертывает FastAPI приложение в Docker контейнере.

**Выполненные задачи:**
1. ✅ Создание директории `/opt/fastapi_app` на сервере
2. ✅ Копирование файлов приложения (main.py, requirements.txt, Dockerfile)
3. ✅ Сборка Docker образа с тегом `fastapi:latest`
4. ✅ Запуск контейнера `fastapi_container`
5. ✅ Проброс порта 80:8000
6. ✅ Настройка политики перезапуска `restart_policy: always`

**Файлы:**
- `ansible-fastapi-hw/roles/fastapi_app/tasks/main.yml`
- `ansible-fastapi-hw/roles/fastapi_app/files/app/main.py`
- `ansible-fastapi-hw/roles/fastapi_app/files/app/requirements.txt`
- `ansible-fastapi-hw/roles/fastapi_app/files/app/Dockerfile`

### Часть 3: Структура проекта

```
ansible-fastapi-hw/
├── playbook.yml                    # Главный playbook
├── inventory                       # Файл с хостами
├── ansible.cfg                     # Конфигурация Ansible
├── README.md                       # Документация
├── .gitignore                      # Git ignore файл
└── roles/
    ├── docker/                     # Роль установки Docker
    │   └── tasks/
    │       └── main.yml
    └── fastapi_app/                # Роль развертывания приложения
        ├── tasks/
        │   └── main.yml
        └── files/
            └── app/
                ├── Dockerfile
                ├── main.py
                └── requirements.txt
```

## Использование

### Установка зависимостей

```bash
# Установка Ansible
pip install ansible

# Установка коллекции community.docker
ansible-galaxy collection install community.docker
```

### Настройка inventory

Отредактируйте `ansible-fastapi-hw/inventory` и укажите IP вашего сервера:

```ini
[webservers]
fastapi-server ansible_host=51.250.87.142 ansible_user=ubuntu
```

### Запуск playbook

```bash
cd ansible-fastapi-hw
ansible-playbook playbook.yml
```

### Проверка результата

После успешного выполнения:

```bash
# Проверка через curl
curl http://51.250.87.142

# Ожидаемый ответ
{"message":"Hello, DevOps World!"}
```

Или откройте в браузере: `http://51.250.87.142`

## Критерии выполнения

### ✅ Код в Git
Весь проект размещен в репозитории с правильной структурой.

### ✅ Идемпотентность
Повторный запуск playbook не вносит изменений (changed=0).

Проверка:
```bash
ansible-playbook playbook.yml
# Первый запуск: changed > 0

ansible-playbook playbook.yml
# Второй запуск: changed = 0
```

### ✅ Результат работы
При обращении к серверу возвращается корректный ответ:

```bash
curl http://51.250.87.142
{"message":"Hello, DevOps World!"}
```

### ✅ Структура проекта
Проект соответствует требуемой структуре с двумя ролями:
- `docker` - установка Docker
- `fastapi_app` - развертывание приложения

## Дополнительные endpoints

Приложение содержит дополнительные endpoints для мониторинга:

```bash
# Health check
curl http://51.250.87.142/health
{"status":"healthy","service":"fastapi"}

# Application info
curl http://51.250.87.142/info
{
  "app":"FastAPI DevOps Demo",
  "version":"1.0.0",
  "framework":"FastAPI",
  "deployment":"Docker + Ansible"
}

# API документация (Swagger UI)
http://51.250.87.142/docs
```

## Особенности реализации

### Код-стайл
- Без комментариев в коде
- Только docstrings в формате Sphinx
- Минималистичные docstrings (описание, аргументы, returns)
- Только top-level импорты
- Без docstrings в шапке файлов

### Идемпотентность
Все задачи написаны с учетом идемпотентности:
- Использование `state: present` вместо команд установки
- Проверка существования ресурсов перед созданием
- Использование модулей Ansible вместо shell команд

### Универсальность
Роли можно переиспользовать для других проектов:
- Роль `docker` не зависит от приложения
- Роль `fastapi_app` легко адаптируется под другие FastAPI проекты

## Управление приложением

```bash
# Проверка статуса контейнера
ansible webservers -m shell -a "docker ps"

# Просмотр логов
ansible webservers -m shell -a "docker logs fastapi_container"

# Перезапуск контейнера
ansible webservers -m shell -a "docker restart fastapi_container"
```

## Заключение

Проект полностью автоматизирует процесс развертывания FastAPI приложения:
1. Установка Docker на чистый сервер
2. Сборка Docker образа приложения
3. Запуск контейнера с автоматическим перезапуском
4. Проброс портов для доступа к приложению

Все требования задания выполнены, проект готов к использованию.
