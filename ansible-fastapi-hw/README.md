# Ansible FastAPI Deployment

Автоматизированное развертывание FastAPI приложения в Docker контейнере с использованием Ansible.

## Структура проекта

```
ansible-fastapi-hw/
├── playbook.yml                    # Главный playbook
├── inventory                       # Список серверов
├── ansible.cfg                     # Конфигурация Ansible
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

## Роли

### docker
Устанавливает и настраивает Docker на целевом сервере:
- Установка зависимостей для репозитория Docker
- Добавление GPG ключа и репозитория Docker
- Установка Docker CE, CLI и containerd
- Установка Python библиотеки docker для управления через Ansible
- Запуск и автозагрузка Docker службы

### fastapi_app
Развертывает FastAPI приложение в Docker контейнере:
- Создание директории приложения
- Копирование файлов приложения на сервер
- Сборка Docker образа из Dockerfile
- Запуск контейнера с проброшенным портом 80:8000
- Настройка автоматического перезапуска контейнера

## Предварительные требования

### На управляющей машине

```bash
# Установка Ansible
pip install ansible

# Установка коллекции community.docker
ansible-galaxy collection install community.docker
```

### На целевом сервере

- Ubuntu 20.04/22.04
- SSH доступ с sudo правами
- Python 3 установлен

## Быстрый старт

### 1. Настройка inventory

Отредактируйте файл `inventory` и укажите IP адрес вашего сервера:

```ini
[webservers]
fastapi-server ansible_host=51.250.87.142 ansible_user=ubuntu
```

### 2. Проверка подключения

```bash
ansible all -m ping
```

Ожидаемый результат:
```
fastapi-server | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### 3. Запуск playbook

```bash
ansible-playbook playbook.yml
```

Процесс займет 3-5 минут при первом запуске.

### 4. Проверка результата

После успешного выполнения проверьте работу приложения:

```bash
# Через curl
curl http://51.250.87.142

# Ожидаемый ответ
{"message":"Hello, DevOps World!"}
```

Или откройте в браузере: `http://51.250.87.142`

### 5. Дополнительные endpoints

```bash
# Health check
curl http://51.250.87.142/health

# Application info
curl http://51.250.87.142/info

# API документация (Swagger UI)
# Откройте в браузере
http://51.250.87.142/docs
```

## Идемпотентность

Playbook является идемпотентным. Повторный запуск не вносит изменений:

```bash
ansible-playbook playbook.yml

# При втором запуске должно быть changed=0
```

Пример вывода при повторном запуске:
```
PLAY RECAP *****************************************************
fastapi-server : ok=15   changed=0   unreachable=0   failed=0
```

## Управление приложением

### Проверка статуса контейнера

```bash
ansible webservers -m shell -a "docker ps"
```

### Просмотр логов

```bash
ansible webservers -m shell -a "docker logs fastapi_container"
```

### Перезапуск контейнера

```bash
ansible webservers -m shell -a "docker restart fastapi_container"
```

### Остановка контейнера

```bash
ansible webservers -m shell -a "docker stop fastapi_container"
```

### Удаление контейнера

```bash
ansible webservers -m shell -a "docker rm -f fastapi_container"
```

## Полезные команды

```bash
# Запуск с verbose режимом
ansible-playbook playbook.yml -v

# Dry-run (проверка без изменений)
ansible-playbook playbook.yml --check

# Запуск только роли docker
ansible-playbook playbook.yml --tags docker

# Запуск только роли fastapi_app
ansible-playbook playbook.yml --tags fastapi_app

# Проверка синтаксиса
ansible-playbook playbook.yml --syntax-check

# Список всех задач
ansible-playbook playbook.yml --list-tasks
```

## Расширение функционала

### Добавление переменных

В `group_vars/webservers.yml`:
```yaml
app_port: 80
container_name: fastapi_container
image_name: fastapi
image_tag: latest
```

### Использование переменных в роли

В `roles/fastapi_app/tasks/main.yml`:
```yaml
- name: Run FastAPI container
  community.docker.docker_container:
    name: "{{ container_name }}"
    image: "{{ image_name }}:{{ image_tag }}"
    ports:
      - "{{ app_port }}:8000"
```

### Добавление handlers

Создайте `roles/fastapi_app/handlers/main.yml`:
```yaml
---
- name: Restart FastAPI container
  community.docker.docker_container:
    name: fastapi_container
    state: started
    restart: yes
```

## Интеграция с CI/CD

Пример использования в GitLab CI:

```yaml
deploy:
  stage: deploy
  script:
    - ansible-playbook -i inventory playbook.yml
  only:
    - main
```

## Безопасность

Рекомендации:
1. Используйте Ansible Vault для хранения чувствительных данных
2. Ограничьте доступ к серверу через firewall
3. Используйте SSL/TLS сертификаты для production
4. Регулярно обновляйте Docker и зависимости

## Дополнительные ресурсы

- [Ansible Documentation](https://docs.ansible.com/)
- [Docker Ansible Collection](https://docs.ansible.com/ansible/latest/collections/community/docker/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
