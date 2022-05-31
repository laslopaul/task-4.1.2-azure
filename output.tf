output "public_ip" {
  description = "WinVM public IP"
  value       = azurerm_public_ip.publicip_winvm.ip_address
}

output "storage_endpoint" {
  description = "Azure Storage endpoint"
  value       = azurerm_storage_account.CorpStorage01.primary_file_endpoint
}

output "storage_access_key" {
  description = "Azure storage access key"
  value       = azurerm_storage_account.CorpStorage01.primary_access_key
  sensitive   = true
}