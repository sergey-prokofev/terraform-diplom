# image_id
data "yandex_compute_image" "ubuntu_24" {
  family = var.default_image
}

# создание адресов для Kubernetes кластера
resource "yandex_vpc_address" "address_cluster" {
  count = 3 
  name        = "static-address-${count.index + 1}" 
  folder_id   = var.folder_id
  description = "static address ${count.index + 1}"

  external_ipv4_address {
    zone_id = "ru-central1-b"
  }
}

# описание ВМ для Kubernetes кластера
resource "yandex_compute_instance" "kub_cluster" {
  count = 3
  name        = "vm-${count.index + 1}"
  zone        = "ru-central1-b"
  platform_id = "standard-v3"
  depends_on = [
    yandex_vpc_address.address_cluster
  ]

  allow_stopping_for_update = true
  
  resources {
    memory = var.vms_resources.memory
    cores  = var.vms_resources.cores
    core_fraction = var.vms_resources.core_fraction
  }

  boot_disk {
    mode = "READ_WRITE"
    initialize_params {
      type = "network-hdd"
      size = 10
      image_id = data.yandex_compute_image.ubuntu_24.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.private.id}"
    nat        = true 
    nat_ip_address = yandex_vpc_address.address_cluster[count.index].external_ipv4_address[0].address
  }

  metadata = {
    user-data = "${file("user-data.yml")}"
  }
}

/*
# описание группы ВМ для Kubernetes кластера
resource "yandex_compute_instance_group" "ig_kub_cluster" {
  name                = "ig-kub-cluster"
  folder_id           = var.folder_id
  service_account_id  = var.service_account_id  #"${yandex_iam_service_account.diplom_sa.id}"
  deletion_protection = false
  depends_on = [
    yandex_vpc_address.address_cluster
  ]
    
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = var.vms_resources.memory
      cores  = var.vms_resources.cores
      core_fraction = var.vms_resources.core_fraction
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        type = "network-hdd"
        size = 10
        image_id = data.yandex_compute_image.ubuntu_24.image_id
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      network_id         = "${yandex_vpc_network.network-1.id}"
      subnet_ids         = ["${yandex_vpc_subnet.private.id}"]
      nat                = true
      #nat_ip_address = yandex_vpc_address.address_cluster[count.index].external_ipv4_address[0].address
    }

    metadata = {
      #user-data = "#cloud-config\nusers:\n  - name: user\n    passwd: 111"
      user-data = "${file("user-data.yml")}"
      #ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCMl12S/xuyqa8R44k2GQ6bfKaEQOV4jN+gSS2uApWrfTI6P62Z906WNO4LBORVLFsvUImp0XfkH/ywiIAWcahFJgKJydJPJyVpMT0BBnTbjHkv6vFGCo8G7jC4bM9i/oq3o3w2xHoOlheFvZ0bSnmhoow3FTSRCpeFJoOP3RaZNCD657G5SRUsLqdsRJ7vaIW6V2j8vKD7EGe3XM0Nm9FlE2DCyLfI4in6ENBdjBLL62EdUJHJ0+JtbPcGhrhQ99rZToObkRg758MACBYGY3YyCvvmY8te4wadRFa77J5TtLSJi9h59m4bqH40XsrA4KmT++MIUzpYHN9UvarGXicKSNskaP3kNmNo5JvbIkKNlenTvHrLMAMnPB/Gl8vNR5gXs6TmQPNm54zBuv9l7PtqutBs9vjfK9d9rCA/dzcWUa3Ty5Q+In7JHRfNKxB8C7L7frVv1fcILg8dfWAsIJsKN+6UJers+Q7bl5u0XvJoeJtreZOYm+toZGSOYwxFrYk= admin1@Debian12"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-b"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
  
  health_check {
    interval = 30
    timeout  = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    http_options {
      path = "/"
      port = 80
    }
  }
}
*/