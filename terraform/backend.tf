# Применяем созданный бакет как бекенд для хранения стейт файла
terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket     = "backend-bucket-104d9ddee52e9ee7" 
    key        = "terraform/terraform.tfstate"
    region     = "ru-central1-a"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    access_key = ""
    secret_key = ""
  }
}