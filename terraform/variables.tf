variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "zone" {
  description = "Yandex Cloud availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.128.0.0/24"
}

variable "bucket_name" {
  description = "Name for Object Storage bucket"
  type        = string
}

variable "storage_access_key" {
  description = "Access key for Object Storage"
  type        = string
  sensitive   = true
}

variable "storage_secret_key" {
  description = "Secret key for Object Storage"
  type        = string
  sensitive   = true
}

variable "vm_cores" {
  description = "Number of CPU cores for VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Amount of RAM in GB for VM"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

variable "ubuntu_image_id" {
  description = "Ubuntu image ID (22.04 LTS)"
  type        = string
  default     = "fd8kdq6d0p8sij7h5qe3"  # Ubuntu 22.04 LTS
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "preemptible" {
  description = "Use preemptible VM (cheaper but can be stopped)"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}
