packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "wordpress" {
  commit = true
  image  = var.docker_source_image
}

build {
  sources = ["source.docker.wordpress"]

  provisioner "shell" {
    script = "install_python.sh"
  }

  provisioner "ansible" {
    playbook_file     = "${path.root}/ansible/playbook.yml"
    extra_arguments   = ["--extra-vars", "ansible_python_interpreter=/usr/bin/python3"]
    ansible_env_vars = ["ANSIBLE_SSH_ARGS='-o IdentitiesOnly=yes'"] # https://github.com/hashicorp/packer/issues/5065
    user = "root"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = var.login_server
      tags = var.docker_image_tag
    }
    post-processor "docker-push" {
      login_server = var.login_server
      ecr_login = true
      aws_access_key = var.aws_access_key_id
      aws_secret_key = var.aws_secret_access_key

    }
  }

}
