#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = "develop-fops-${var.flow}"
}

#создаем подсеть zone A
resource "yandex_vpc_subnet" "develop_a" {
  name           = "develop-fops-${var.flow}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаем подсеть zone B
resource "yandex_vpc_subnet" "develop_b" {
  name           = "develop-fops-${var.flow}-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаем NAT для выхода в интернет
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "fops-gateway-${var.flow}"
  shared_egress_gateway {}
}

#создаем сетевой маршрут для выхода в интернет через NAT
resource "yandex_vpc_route_table" "rt" {
  name       = "fops-route-table-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

#создаем группы безопасности

resource "yandex_vpc_security_group" "bastion" {
  name       = "bastion-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}


resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id
  ingress {
    description    = "Allow 10.0.0.0/8"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.0.0/8"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "web_sg" {
  name       = "web_sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    protocol       = "TCP"
    port           = 4040
    v4_cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "alb" {
  name       = "alb"
  network_id = yandex_vpc_network.develop.id
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "zabbix" {
  name       = "zabbix"
  network_id = yandex_vpc_network.develop.id
  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "yandex_vpc_security_group" "kibana" {
  name       = "kibana"
  network_id = yandex_vpc_network.develop.id
  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "yandex_vpc_security_group" "elasticsearch" {
  name       = "elasticsearch"
  network_id = yandex_vpc_network.develop.id

  ingress {
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.0.0/8"]
  }
}
