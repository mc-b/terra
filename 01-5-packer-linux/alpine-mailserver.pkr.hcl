
variable "output_dir" {
  type = string
  default = "output/alpine-mailserver"
}


source "hyperv-iso" "alpine-mailserver" {
  boot_command = ["<enter><wait10>", "root<enter><wait>",
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/generic.alpine319.vagrant.cfg<enter><wait>",
    "sed -i -e \"/rc-service/d\" /sbin/setup-sshd<enter><wait>",
    "source generic.alpine319.vagrant.cfg<enter><wait>",
    "printf \"vagrant\\nvagrant\\n\" | sh /sbin/setup-alpine -f /root/generic.alpine319.vagrant.cfg && ",
    "mount /dev/sda2 /mnt && ",
    "sed -E -i '/#? ?PasswordAuthentication/d' /mnt/etc/ssh/sshd_config && ",
    "sed -E -i '/#? ?PermitRootLogin/d' /mnt/etc/ssh/sshd_config && ",
    "echo 'PasswordAuthentication yes' >> /mnt/etc/ssh/sshd_config && ",
    "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config && ",
    "chroot /mnt apk add openntpd && chroot /mnt rc-update add openntpd default && ",
    "chroot /mnt apk add hvtools && chroot /mnt rc-update add hv_fcopy_daemon default && ",
  "chroot /mnt rc-update add hv_kvp_daemon default && chroot /mnt rc-update add hv_vss_daemon default && reboot<enter>"]
  boot_keygroup_interval           = "1s"
  boot_wait                        = "60s"
  communicator                     = "ssh"
  cpus                             = 1
  disk_size                        = 512
  enable_dynamic_memory            = false
  enable_mac_spoofing              = false
  enable_secure_boot               = false
  enable_virtualization_extensions = false
  generation                       = 1
  guest_additions_mode             = "disable"
  headless                         = false
  http_directory                   = "http"
  iso_checksum                     = "sha256:366317d854d77fc5db3b2fd774f5e1e5db0a7ac210614fd39ddb555b09dbb344"
  iso_url                          = "https://mirrors.edge.kernel.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.1-x86_64.iso"
  memory                           = 512
  output_directory                 = "output/alpine-mailserver"
  shutdown_command                 = "/sbin/poweroff"
  skip_compaction                  = false
  ssh_handshake_attempts           = 1000
  ssh_password                     = "vagrant"
  ssh_port                         = 22
  ssh_timeout                      = "7200s"
  ssh_username                     = "root"
  temp_path                        = "output/"
  vm_name                          = "alpine-mailserver"
  switch_name                      = "Default Switch"
}
source "file" "dummy" {
    content = "dummy"
     target = "./dummy.txt"
}

build {
  sources = ["source.hyperv-iso.alpine-mailserver", "source.file.dummy"]

  provisioner "shell" {
    only                = [ "source.hyperv-iso.alpine-mailserver" ]
    execute_command     = "{{ .Vars }} /bin/ash '{{ .Path }}'"
    expect_disconnect   = "true"
    pause_before        = "2m0s"
    scripts             = ["scripts/alpine319/postfix.sh"]
    start_retry_timeout = "45m"
    timeout             = "2h0m0s"
  }

  post-processors {

    post-processor "compress" {
      output = "output/alpine-mailserver/Virtual Hard Disks/alpine-mailserver.tar.gz"
    }
    
    post-processor "shell-local" {
        inline = ["qemu-img.exe convert -O qcow2 \"output/alpine-mailserver/Virtual Hard Disks/alpine-mailserver.vhdx\" \"output/alpine-mailserver/Virtual Hard Disks/alpine-mailserver.qcow2\""]
    }
  }
}





