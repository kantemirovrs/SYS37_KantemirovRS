#Создаём Target Group, включаем в неё две созданных ВМ.
resource "yandex_alb_target_group" "target-group" {
  name = "target-group"
  target {
    subnet_id  = yandex_vpc_subnet.develop_a.id
    ip_address = yandex_compute_instance.web_a.network_interface.0.ip_address
  }
  target {
    subnet_id  = yandex_vpc_subnet.develop_b.id
    ip_address = yandex_compute_instance.web_b.network_interface.0.ip_address
  }
}

#Создаём Backend Group, настраиваем backends на target group. 
resource "yandex_alb_backend_group" "backend-group" {
  name = "backend-group"
  http_backend {
    name             = "http-backend"
    weight           = 1
    port             = 80
    target_group_ids = ["${yandex_alb_target_group.target-group.id}"]
    healthcheck {
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}

#Создаём HTTP router.
resource "yandex_alb_http_router" "http-router" {
  name = "http-router"
}
resource "yandex_alb_virtual_host" "virtual-host" {
  name           = "virtual-host"
  http_router_id = yandex_alb_http_router.http-router.id
  route {
    name = "route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
        timeout          = "60s"
      }
    }
  }
}

#Создаём Application load balancer.
resource "yandex_alb_load_balancer" "load-balancer" {
  name               = "load-balancer"
  network_id         = yandex_vpc_network.develop.id
  security_group_ids = [yandex_vpc_security_group.alb.id]
  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.develop_a.id
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.develop_b.id
    }
  }
  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }
}

#Создаём и настраиваем snapshot" 
resource "yandex_compute_snapshot_schedule" "default" {
  name = "snapshot"
  schedule_policy {
    expression = "0 0 * * *"
  }
  snapshot_count   = 7
  retention_period = "24h"
  snapshot_spec {
    description = "snapshot-description"
    labels = {
      snapshot-label = "hdd"
    }
  }
  labels = {
    my-label = "hdd"
  }
  disk_ids = [yandex_compute_instance.bastion.boot_disk.0.disk_id,
    yandex_compute_instance.web_a.boot_disk.0.disk_id,
    yandex_compute_instance.web_b.boot_disk.0.disk_id,
    yandex_compute_instance.zabbix.boot_disk.0.disk_id,
    yandex_compute_instance.elasticsearch.boot_disk.0.disk_id,
  yandex_compute_instance.kibana.boot_disk.0.disk_id]
}
