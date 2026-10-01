terraform {
  required_version = ">= 1.6"
  required_providers {
    yandex = { source = "yandex-cloud/yandex" }
  }
  backend "s3" {
    bucket                      = "devsecops-lab-tfstate-pet-project"
    key                         = "lab/terraform.tfstate"
    region                      = "ru-central1"
    endpoints                   = { s3 = "https://storage.yandexcloud.net" }
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}
