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
  token     = "t1.9euelZqakJmLipiXzpKVmpjPm42Pz-3rnpWalJ6YkZvGnJScnp6ciZKVmZjl9PcMcSxD-e8dHSXS3fT3TB8qQ_nvHR0l0s3n9euelZqWzsrLz5qemZSdl5SLzMmOju_8zef1656VmseTzseZjcqamI6Mi47LzZuK7_3F656VmpbOysvPmp6ZlJ2XlIvMyY6O.TDyJTfAV9qh5zSqIzFBU28I41K7QSeO0YBqwJyiVM2g_SrL4akQUCt1qWES9GIikkQZC5EPQPEkxpEw3WQ3aDQ"
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
        - cd /home/ubuntu/project
        - pip3 install virtualenv
        - virtualenv /opt/rasa_env
        - /opt/rasa_env/bin/pip install rasa transformers
        - /opt/rasa_env/bin/rasa train >> /home/ubuntu/rasa_train.log 2>&1
        - nohup /opt/rasa_env/bin/rasa run actions --cors "*" --port 5055 > /home/ubuntu/rasa_actions.log 2>&1 &
        - nohup /opt/rasa_env/bin/rasa run --cors "*" --debug > /home/ubuntu/rasa_server.log 2>&1
        - npm install
        - npm run build
        - npm run start
        - echo "Project backend and frontend are running!" > /home/ubuntu/project_status.log
    EOT
  }
}
