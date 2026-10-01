data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "lab" {
  name = "devsecops-lab-net"
}

resource "yandex_vpc_subnet" "lab" {
  name           = "devsecops-lab-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.lab.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

resource "yandex_vpc_security_group" "lab" {
  name       = "devsecops-lab-sg"
  network_id = yandex_vpc_network.lab.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "app" {
  name        = "devsecops-app"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.lab.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.lab.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(pathexpand(var.ssh_public_key_path))}"
  }
}
