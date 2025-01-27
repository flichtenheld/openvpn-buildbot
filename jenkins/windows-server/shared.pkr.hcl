packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  user_name = "Administrator"
}

variable "windows_server_buildbot_user_password" {
  type = string
}

variable "windows_server_ec2_region" {
  type = string
}

variable "windows_server_ec2_subnet" {
  type = string
  default = null
}

variable "windows_server_winrm_password" {
  type = string
}

variable "jenkinsmaster_address" {
  type = string
}

source "amazon-ebs" "windows-server-2019" {
  communicator     = "winrm"
  force_deregister = true
  instance_type    = "t3a.large"
  region           = var.windows_server_ec2_region
  subnet_id        = var.windows_server_ec2_subnet

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 80
    volume_type = "gp2"
    delete_on_termination = true
  }

  source_ami_filter {
    filters     = {
      name                = "Windows_Server-2019-English-Full-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["801119661308"]
  }
  user_data        = templatefile("${path.root}/../../pkrtpl/bootstrap_win.pkrtpl.hcl", { winrm_password = var.windows_server_winrm_password })
  winrm_password   = var.windows_server_winrm_password
  winrm_username   = "Administrator"

  tags          = {
    SourceAMI     = "{{ .SourceAMI }}"
    SourceAMIName = "{{ .SourceAMIName }}"
    Login         = local.user_name
  }
}

source "amazon-ebs" "windows-server-2022" {
  communicator     = "winrm"
  force_deregister = true
  instance_type    = "t3a.large"
  region           = var.windows_server_ec2_region
  subnet_id        = var.windows_server_ec2_subnet

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 80
    volume_type = "gp2"
    delete_on_termination = true
  }

  source_ami_filter {
    filters     = {
      name                = "Windows_Server-2022-English-Full-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["801119661308"]
  }
  user_data        = templatefile("${path.root}/../../pkrtpl/bootstrap_win.pkrtpl.hcl", { winrm_password = var.windows_server_winrm_password })
  winrm_password   = var.windows_server_winrm_password
  winrm_username   = "Administrator"

  tags          = {
    SourceAMI     = "{{ .SourceAMI }}"
    SourceAMIName = "{{ .SourceAMIName }}"
    Login         = local.user_name
  }
}
