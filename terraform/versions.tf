terraform {
  required_version = "> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}
