
source "hyperv-iso" "ubuntu-database" {
  boot_command                      = ["<tab><wait><tab><wait><tab><wait><tab><wait><tab><wait><tab><wait>",
                                    "c<wait10>", "set gfxpayload=keep<enter><wait10>",
                                    "linux /casper/vmlinuz autoinstall quiet net.ifnames=0 biosdevname=0 ",
                                    "cloud-config-url=\"http://{{ .HTTPIP }}:{{ .HTTPPort }}/generic.ubuntu2204.vagrant.cfg\" --- <enter><wait10>", "initrd /casper/initrd<enter><wait10>", "boot<enter>"]
  boot_keygroup_interval           = "1s"
  boot_wait                        = "10s"
  communicator                     = "ssh"
  cpus                             = 2
  disk_size                        = 8192
  enable_dynamic_memory            = false
  enable_mac_spoofing              = false
  enable_secure_boot               = false
  enable_virtualization_extensions = false
  generation                       = 1
  guest_additions_mode             = "disable"
  headless                         = false
  http_directory                   = "http"
  iso_checksum                     = "sha256:45f873de9f8cb637345d6e66a583762730bbea30277ef7b32c9c3bd6700a32b2"
  iso_url                          = "https://releases.ubuntu.com/22.04/ubuntu-22.04.4-live-server-amd64.iso"
  memory                           = 2048
  output_directory                 = "output/ubuntu-database"
  shutdown_command                 = "echo 'vagrant' | sudo -S shutdown -P now"
  skip_compaction                  = false
  ssh_handshake_attempts           = 1000
  ssh_password                     = "vagrant"
  ssh_port                         = 22
  ssh_timeout                      = "7200s"
  ssh_username                     = "root"
  temp_path                        = "output/"
  vm_name                          = "ubuntu-database"
  switch_name                      = "Default Switch"
}

build {
  sources = ["source.hyperv-iso.ubuntu-database"]
 
  provisioner "shell" {
    pause_before      = "2m0s"
    scripts           = ["scripts/ubuntu2204/mysql.sh",
                        "scripts/ubuntu2204/adminer.sh"]
    start_retry_timeout = "45m"
    timeout             = "2h0m0s"
  }  
}