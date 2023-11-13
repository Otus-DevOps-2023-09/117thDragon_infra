variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}
variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}
variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "privat_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "image_id" {
  description = "Disk image"
}
variable "subnet_id" {
  description = "Subnet"
  type        = string
}
variable "service_account_key_file" {
  description = "key .json"
  type        = string
  default     = "key.json"
}
variable "instance_count" {
  description = "Number of instances to provision."
  type        = number
  default     = 2
}
variable "region_id" {
  description = "region"
  type        = string
  default     = "ru-central1"
}
