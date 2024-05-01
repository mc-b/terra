
# Variablen

variable "disk_size" {
  type    = string
  default = "32768"
}

variable "iso_checksum" {
  type    = string
  default = "f11bda2f2caed8f420802b59f382c25160b114ccc665dbac9c5046e7fceaced2"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_url" {
  type    = string
  default = "http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/ubuntu-20.04.1-legacy-server-amd64.iso"
}

variable "vm_name" {
  type    = string
  default = "ubuntu-focal-server"
}

# Meta Data

source "hyperv-iso" "ubuntu_20_server" {
  boot_command       = ["<esc><wait10><esc><esc><enter><wait>", "set gfxpayload=1024x768<enter>", "linux /install/vmlinuz ", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed-hyperv.cfg ", "debian-installer=en_US.UTF-8 auto locale=en_US.UTF-8 kbd-chooser/method=us ", "hostname={{ .Name }} ", "fb=false debconf/frontend=noninteractive ", "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ", "keyboard-configuration/variant=USA console-setup/ask_detect=false <enter>", "initrd /install/initrd.gz<enter>", "boot<enter>"]
  boot_wait            = "5s"
  communicator         = "ssh"
  disk_size            = "${var.disk_size}"
  enable_secure_boot   = false
  generation           = 2
  headless             = false
  guest_additions_mode = "disable"
  http_directory       = "./"
  iso_checksum         = "${var.iso_checksum}"
#  iso_checksum_type    = "sha256"
  iso_url              = "${var.iso_url}"
  shutdown_command     = "echo 'ubuntu' | sudo -S -E shutdown -P now"
  ssh_username         = "ubuntu"
  ssh_password         = "insecure"
  ssh_timeout          = "1h"
  vm_name              = "${var.vm_name}"
  switch_name          = "Default Switch"  

}

# Output Directory

build {
  sources = ["source.hyperv-iso.ubuntu_20_server"]

}
