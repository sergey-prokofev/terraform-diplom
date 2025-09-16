# Выводим информацию о созданных ресурсах
output "ipv4_address_master" {
    value = yandex_compute_instance.kub_cluster[0].network_interface.0.nat_ip_address
}

output "ipv4_address_worker1" {
    value = yandex_compute_instance.kub_cluster[1].network_interface.0.nat_ip_address
}

output "ipv4_address_worker2" {
    value = yandex_compute_instance.kub_cluster[2].network_interface.0.nat_ip_address
}
