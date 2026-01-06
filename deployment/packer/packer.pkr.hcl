packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.8.0"
    }
  }
}

variable "local_jar_path" {
  type        = string
  description = ".jar file path on local machine"
}

variable "local_jar_name" {
  type        = string
  description = ".jar artifact name"
}

variable "ami_temp_path" {
  type    = string
  default = "/tmp"
}

variable "ami_app_path" {
  type    = string
  default = "/opt/app"
}

variable "app_service_file_name" {
  type    = string
  default = "application.service"
}

variable "jvm_options_file_name" {
  type    = string
  default = "jvm.options"
}

variable "cloudwatch_config_file_name" {
  type    = string
  default = "cloudwatch-config.json"
}

source "amazon-ebs" "trade_signals" {
  region                      = "ap-southeast-1"
  instance_type               = "t3.micro"
  ssh_username                = "ec2-user"
  ami_name                    = "trade-signals-app-{{timestamp}}"
  ami_description             = "Trade Signals App AMI"
  security_group_ids = ["sg-0e2b0c1ad71a16e31"]
  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name = "amzn2-ami-hvm-*-x86_64-gp2"
    }
    owners = ["137112412989"]
    most_recent = true
  }

  tags = {
    trade-signals = "trade-signals-ami"
  }
}

build {
  sources = ["source.amazon-ebs.trade_signals"]

  provisioner "shell" {
    script = "${path.root}/scripts/install_dependencies.sh"
  }

  provisioner "file" {
    source      = var.local_jar_path
    destination = "${var.ami_temp_path}/${var.local_jar_name}"
  }

  provisioner "shell" {
    script = "${path.root}/scripts/copy_app.sh"
    environment_vars = [
      "AMI_TEMP_PATH=${var.ami_temp_path}",
      "AMI_APP_PATH=${var.ami_app_path}",
      "JAR_NAME=${var.local_jar_name}"
    ]
  }

  provisioner "file" {
    source      = "${path.root}/../configs/${var.app_service_file_name}"
    destination = "${var.ami_temp_path}/${var.app_service_file_name}"
  }

  provisioner "file" {
    source      = "${path.root}/../configs/${var.jvm_options_file_name}"
    destination = "${var.ami_temp_path}/${var.jvm_options_file_name}"
  }

  provisioner "shell" {
    script = "${path.root}/scripts/setup_systemd.sh"
    environment_vars = [
      "AMI_JAR_PATH=${var.ami_app_path}/${var.local_jar_name}",
      "AMI_TEMP_PATH=${var.ami_temp_path}",
      "SERVICE_FILE_NAME=${var.app_service_file_name}",
      "JVM_OPTIONS_FILE=${var.jvm_options_file_name}"
    ]
  }

  provisioner "file" {
    source      = "${path.root}/../configs/${var.cloudwatch_config_file_name}"
    destination = "${var.ami_temp_path}/${var.cloudwatch_config_file_name}"
  }

  provisioner "shell" {
    script = "${path.root}/scripts/setup_cloudwatch.sh"
    environment_vars = [
      "AMI_JAR_PATH=${var.ami_app_path}/${var.local_jar_name}",
      "AMI_TEMP_PATH=${var.ami_temp_path}",
      "CLOUDWATCH_CONFIG_FILE_NAME=${var.cloudwatch_config_file_name}"
    ]
  }

  provisioner "shell" {
    script = "${path.root}/scripts/cleanup.sh"
    environment_vars = [
      "AMI_TEMP_PATH=${var.ami_temp_path}",
    ]
  }
}
