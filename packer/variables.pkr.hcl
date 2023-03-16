variable "aws_access_key_id" {
  type    = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
}

variable "aws_secret_access_key" {
  type    = string
  default = "${env("AWS_SECRET_ACCESS_KEY")}"
}

variable "docker_source_image" {
  type    = string
  default = "php:apache-bullseye"
}

variable "docker_image_tag" {
  type    = list(string)
  default = ["latest"]
}

variable "login_server" {
  type    = string
  default = "${env("AWS_REPOSITORY_LOGIN_URL")}"
}
