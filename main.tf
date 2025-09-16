# Создаем сервисный аккаунт для работы
resource "yandex_iam_service_account" "diplom_sa" {
  name        = "diplom-service-account"
  description = "Service account for diplom project test"
}

# Назначаем права сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_binding" "editor_roles" {
  folder_id = var.folder_id
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.diplom_sa.id}"
  ]
}

# Создаем статические ключи доступа для сервисного аккаунта
resource "yandex_iam_service_account_static_access_key" "sa_keys" {
  service_account_id = yandex_iam_service_account.diplom_sa.id
  description        = "Static access key for sa"
}

# Генерируем случайный суффикс для имени бакета
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# Создаем бакет в Object Storage
resource "yandex_storage_bucket" "backend_bucket" {
  bucket     = "backend-bucket-${random_id.bucket_suffix.hex}"
  folder_id = var.folder_id
  max_size   = 1073741824

  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  access_key = yandex_iam_service_account_static_access_key.sa_keys.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_keys.secret_key
}
