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
  token     = "t1.9euelZqWx5OemcmRx8vOzsaZiZDPzu3rnpWalJ6YkZvGnJScnp6ciZKVmZjl8_dKJ0xD-e8gNkoL_t3z9wpWSUP57yA2Sgv-zef1656VmszNm8qLzImMzcqcnIyezMqS7_zN5_XrnpWax5POx5mNypqYjoyLjsvNm4rv_cXrnpWazM2byovMiYzNypycjJ7MypI.aYKOV5CRlACHWZymIqamp3H8UW9ClVqfW0pfj9TLWEAC0w9T6J2h8yav5DR4kuNYCMBPy4_Bf4EMdnJWECAeBA"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "vm" {
  name = "terraform-instance"
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
    user-data = <<-EOT
      #cloud-config
      package_update: true
      package_upgrade: true
      packages:
        - python3
        - python3-pip
        - build-essential
        - libssl-dev
        - libffi-dev
        - python3-dev
        - curl
        - git
        - nodejs
        - npm
      runcmd:
        - echo "Attempting to clone repository" > /home/ubuntu/clone_debug.log
        - apt-get update && apt-get install -y git >> /home/ubuntu/debug.log 2>&1
        - git clone --branch sprint-5 https://github.com/baidinvladislav/architecture-sprint-5.git /home/ubuntu/project >> /home/ubuntu/debug.log 2>&1
        - cd /home/ubuntu
        - pip3 install virtualenv
        - virtualenv /opt/rasa_env
        - /opt/rasa_env/bin/pip install rasa transformers
        - /opt/rasa_env/bin/rasa train
        - /opt/rasa_env/bin/rasa run actions
        - /opt/rasa_env/bin/rasa run --cors "*"
        - npm install
        - npm run build
        - npm run start
        - echo "Project backend and frontend are running!" > /root/project_status.txt
    EOT
  }
}
