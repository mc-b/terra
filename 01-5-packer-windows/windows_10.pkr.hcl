
variable "autounattend" {
  type    = string
  default = "./answer_files/10/Autounattend.xml"
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

variable "iso_checksum" {
  type    = string
  default = "sha256:ef7312733a9f5d7d51cfa04ac497671995674ca5e1058d5164d6028f0938d668"
}

variable "iso_url" {
  type    = string
  default = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "restart_timeout" {
  type    = string
  default = "5m"
}

variable "vhv_enable" {
  type    = string
  default = "false"
}

variable "virtio_win_iso" {
  type    = string
  default = "~/virtio-win.iso"
}

variable "vm_name" {
  type    = string
  default = "windows_10"
}

variable "vmx_version" {
  type    = string
  default = "14"
}

variable "winrm_timeout" {
  type    = string
  default = "6h"
}

source "hyperv-iso" "windows_10" {
  boot_wait             = "6m"
  communicator          = "winrm"
  configuration_version = "8.0"
  cpus                  = "2"
  disk_size             = "${var.disk_size}"
  floppy_files          = ["${var.autounattend}", "./floppy/WindowsPowershell.lnk", "./floppy/PinTo10.exe", "./scripts/fixnetwork.ps1", "./scripts/disable-screensaver.ps1", "./scripts/disable-winrm.ps1", "./scripts/enable-winrm.ps1", "./scripts/microsoft-updates.bat", "./scripts/win-updates.ps1"]
  guest_additions_mode  = "none"
  iso_checksum          = "${var.iso_checksum}"
  iso_url               = "${var.iso_url}"
  memory                = "${var.memory}"
  shutdown_command      = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  switch_name           = "Default Switch"
  vm_name               = "${var.vm_name}"
  winrm_password        = "vagrant"
  winrm_timeout         = "${var.winrm_timeout}"
  winrm_username        = "vagrant"
}

source "file" "dummy" {
    content = "dummy"
     target = "./dummy.txt"
}

build {
  sources = ["source.hyperv-iso.windows_10", "source.file.dummy"]

  provisioner "windows-shell" {
    only            = ["source.hyperv-iso.windows_10"]  
    execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
    remote_path     = "/tmp/script.bat"
    scripts         = ["./scripts/enable-rdp.bat"]
  }

  provisioner "powershell" {
    only            = ["source.hyperv-iso.windows_10"]  
    scripts = ["./scripts/vm-guest-tools.ps1", "./scripts/debloat-windows.ps1"]
  }

  provisioner "windows-restart" {
    only            = ["source.hyperv-iso.windows_10"]  
    restart_timeout = "${var.restart_timeout}"
  }

  provisioner "powershell" {
    only            = ["source.hyperv-iso.windows_10"]  
    scripts = ["./scripts/set-powerplan.ps1", "./scripts/docker/disable-windows-defender.ps1"]
  }

  provisioner "windows-shell" {
    only            = ["source.hyperv-iso.windows_10"]  
    execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
    remote_path     = "/tmp/script.bat"
    scripts         = ["./scripts/pin-powershell.bat", "./scripts/compile-dotnet-assemblies.bat", "./scripts/set-winrm-automatic.bat", "./scripts/uac-enable.bat", "./scripts/dis-updates.bat", "./scripts/compact.bat"]
  }
  
  post-processors {
  
      /**
      post-processor "vagrant" {
        only            = ["source.hyperv-iso.windows_10"]  
        keep_input_artifact  = true
        output               = "windows_10_{{ .Provider }}.box"
        vagrantfile_template = "vagrantfile-windows_10.template"
      }*/  

    post-processor "compress" {
      output = "output-windows_10/Virtual Hard Disks/windows_10.tar.gz"
    }
    
    post-processor "shell-local" {
        inline = ["qemu-img.exe convert -O qcow2 \"output-windows_10/Virtual Hard Disks/windows_10.vhdx\" \"output-windows_10/Virtual Hard Disks/windows_10.qcow2\""]
    }
  }   
}
