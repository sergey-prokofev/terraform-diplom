variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}


#----------------------------------------------------------------------------------


variable "default_image" {
  type        = string
  default     = "ubuntu-2404-lts-oslogin"
  description = "family_id: Ubuntu 24.04 LTS"
}

variable "vms_resources" {
  type       = object({
    cores    = number
    memory   = number
    core_fraction = number
  })
  description = "resources for VM"
}

variable "service_account_id" {
  type        = string
  description = "family_id: Ubuntu 20.04 LTS"
}

variable "target_port" {
  type        = string
  default     = 80
  description = "NodePort to ingress-nginx-controller"
}