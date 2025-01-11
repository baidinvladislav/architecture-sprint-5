terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84"
    }
  }
}

provider "yandex" {
  folder_id = "b1gpijacueemuiv6g27k"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "vm" {
  name = "test-vm"
  zone = "ru-central1-b"

  resources {
    cores  = 2
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id = "e2l4e88obkj32hkqspq8"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}