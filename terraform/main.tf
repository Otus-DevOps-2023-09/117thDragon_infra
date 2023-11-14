terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "/home/admins/otus/secrets/terraform-key.json"
  cloud_id  = "b1g0pi5g5inulu013ia8"
  folder_id = "b1g9rbhfq6ba8dfpgv37"
  zone      = "ru-central1-a"
}
