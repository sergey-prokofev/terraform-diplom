# Создаем целевую группу
resource "yandex_lb_target_group" "target-group-1" {
  name      = "target-group-1"
  depends_on = [
    yandex_compute_instance.kub_cluster,
  ]

  target {
    subnet_id = yandex_vpc_subnet.private.id
    address   = yandex_compute_instance.kub_cluster[1].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.private.id
    address   = yandex_compute_instance.kub_cluster[2].network_interface.0.ip_address
  }
}

# Создаем сетевой балансировщик
resource "yandex_lb_network_load_balancer" "balancer" {
  name = "balancer"

  listener {
    name = "my-listener"
    port = 80
    target_port = var.target_port
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target-group-1.id
    
    healthcheck {
      name = "http-healthcheck"
      tcp_options {  # Используем TCP-проверку
        port = var.target_port # Порт, который проверяем (например, порт Grafana)
      }
      #http_options {
      #  port = 10248
      #  path = "/healthz" 
      #}
    }
  }
}