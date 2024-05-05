
variable "autounattend" {
  type    = string
  default = "./answer_files/2022/Autounattend.xml"
}

variable "disk_size" {
  type    = string
  default = "61440"
}

variable "disk_type_id" {
  type    = string
  default = "1"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "hyperv_switchname" {
  type    = string
  default = "Default Switch"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
}

variable "iso_url" {
  type    = string
  default = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
}

variable "manually_download_iso_from" {
  type    = string
  default = "https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "restart_timeout" {
  type    = string
  default = "5m"
}

variable "virtio_win_iso" {
  type    = string
  default = "~/virtio-win.iso"
}

variable "vmx_version" {
  type    = string
  default = "14"
}

variable "winrm_timeout" {
  type    = string
  default = "2h"
}

source "hyperv-iso" "windows_2022" {
  boot_wait                        = "0s"
  communicator                     = "winrm"
  configuration_version            = "8.0"
  cpus                             = 2
  disk_size                        = "${var.disk_size}"
  enable_secure_boot               = true
  enable_virtualization_extensions = true
  floppy_files                     = ["${var.autounattend}", "./scripts/disable-screensaver.ps1", "./scripts/disable-winrm.ps1", "./scripts/enable-winrm.ps1", "./scripts/microsoft-updates.bat", "./scripts/unattend.xml", "./scripts/sysprep.bat", "./scripts/win-updates.ps1"]
  guest_additions_mode             = "disable"
  iso_checksum                     = "${var.iso_checksum}"
  iso_url                          = "${var.iso_url}"
  memory                           = "${var.memory}"
  shutdown_command                 = "a:/sysprep.bat"
  switch_name                      = "${var.hyperv_switchname}"
  vm_name                          = "WindowsServer2022"
  winrm_password                   = "vagrant"
  winrm_timeout                    = "${var.winrm_timeout}"
  winrm_username                   = "vagrant"
}

build {
  sources = ["source.hyperv-iso.windows_2022"]

  provisioner "windows-shell" {
    execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
    scripts         = ["./scripts/enable-rdp.bat"]
  }

  provisioner "powershell" {
    scripts = ["./scripts/vm-guest-tools.ps1", "./scripts/debloat-windows.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "${var.restart_timeout}"
  }

  provisioner "windows-shell" {
    execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
    scripts         = ["./scripts/pin-powershell.bat", "./scripts/set-winrm-automatic.bat", "./scripts/uac-enable.bat", "./scripts/compile-dotnet-assemblies.bat", "./scripts/dis-updates.bat", "./scripts/compact.bat"]
  }

  post-processors {
    
    post-processor "shell-local" {
        inline = ["qemu-img.exe convert -O qcow2 \"output-windows_2022/Virtual Hard Disks/WindowsServer2022.vhdx\" \"output-windows_2022/Virtual Hard Disks/WindowsServer2022.qcow2\""]
    }
  }    
}
