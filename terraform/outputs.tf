output "vm_external_ip" {
  description = "External IP address of the VM"
  value       = yandex_compute_instance.firewatch_vm.network_interface[0].nat_ip_address
}

output "vm_internal_ip" {
  description = "Internal IP address of the VM"
  value       = yandex_compute_instance.firewatch_vm.network_interface[0].ip_address
}

output "vm_id" {
  description = "ID of the created VM"
  value       = yandex_compute_instance.firewatch_vm.id
}

output "vm_name" {
  description = "Name of the VM"
  value       = yandex_compute_instance.firewatch_vm.name
}

output "ssh_connection_string" {
  description = "SSH connection command"
  value       = "ssh ubuntu@${yandex_compute_instance.firewatch_vm.network_interface[0].nat_ip_address}"
}

output "bucket_name" {
  description = "Name of the created storage bucket"
  value       = yandex_storage_bucket.firewatch_data.bucket
}

output "network_id" {
  description = "ID of the VPC network"
  value       = yandex_vpc_network.firewatch_network.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = yandex_vpc_subnet.firewatch_subnet.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = yandex_vpc_security_group.firewatch_sg.id
}

output "api_endpoint" {
  description = "FastAPI endpoint URL"
  value       = "http://${yandex_compute_instance.firewatch_vm.network_interface[0].nat_ip_address}:8000"
}
