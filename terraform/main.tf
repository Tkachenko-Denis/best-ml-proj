terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
  required_version = ">= 1.0"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

# Создание VPC
resource "yandex_vpc_network" "firewatch_network" {
  name        = "firewatch-network"
  description = "Network for FireWatch.ai project"
}

# Создание подсети
resource "yandex_vpc_subnet" "firewatch_subnet" {
  name           = "firewatch-subnet"
  description    = "Subnet for FireWatch.ai VMs"
  v4_cidr_blocks = [var.subnet_cidr]
  zone           = var.zone
  network_id     = yandex_vpc_network.firewatch_network.id
}

# Группа безопасности
resource "yandex_vpc_security_group" "firewatch_sg" {
  name        = "firewatch-security-group"
  description = "Security group for FireWatch.ai"
  network_id  = yandex_vpc_network.firewatch_network.id

  ingress {
    protocol       = "TCP"
    description    = "SSH access"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "FastAPI application"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8000
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Object Storage бакет для данных
resource "yandex_storage_bucket" "firewatch_data" {
  bucket     = var.bucket_name
  access_key = var.storage_access_key
  secret_key = var.storage_secret_key

  anonymous_access_flags {
    read = false
    list = false
  }

  versioning {
    enabled = true
  }

  tags = {
    project = "firewatch"
    purpose = "ml-data-storage"
  }
}

# Виртуальная машина для ML модели
resource "yandex_compute_instance" "firewatch_vm" {
  name        = "firewatch-ml-server"
  platform_id = "standard-v2"
  zone        = var.zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = var.disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.firewatch_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.firewatch_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
    user-data = templatefile("${path.module}/cloud-init.yaml", {
      ssh_key = file(var.ssh_public_key_path)
    })
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  labels = {
    project     = "firewatch"
    environment = var.environment
    role        = "ml-server"
  }
}
