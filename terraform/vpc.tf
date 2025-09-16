# Создаем VPC
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}
# Создаем subnet public
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.default_zone
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Создаем subnet private
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["192.168.20.0/24"]
}


