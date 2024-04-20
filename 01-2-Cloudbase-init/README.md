## Übung 01-2: Infrastruktur als Code - Cloudbase-init

«Cloud-Init ist der Standard für die automatische Installation von Linux basierenden Systemen in der Cloud. 

Cloudbase-Init™ ist das Windows-Äquivalent des Cloud-Init-Projekts.

Laut ChatGPT kann mittels folgendem PowerShell Script eine VM, inkl. Cloud-init Script, erstellt werden

    # Variablen definieren
    $VMName = "MeineCloudVM"
    $VMPath = "C:\VMs\$VMName"
    $VMVHDPath = "$VMPath\$VMName.vhdx"
    $ISOPath = "C:\Pfad\zum\WindowsImage.iso"
    $VMNetwork = "Default Switch"  # Der Name des virtuellen Netzwerkschalters in Hyper-V
    
    # Virtuelle Maschine erstellen
    New-VM -Name $VMName -Path $VMPath -MemoryStartupBytes 4GB -NewVHDPath $VMVHDPath -NewVHDSizeBytes 60GB
    
    # ISO-Datei als DVD-Laufwerk hinzufügen
    Add-VMDvdDrive -VMName $VMName -Path $ISOPath
    
    # Netzwerkkarte hinzufügen
    Add-VMNetworkAdapter -VMName $VMName -SwitchName $VMNetwork
    
    # VM starten
    Start-VM -Name $VMName
    
    # Warten bis die VM gestartet ist
    Start-Sleep -Seconds 60
    
    # Cloudbase-init Konfiguration
    $CloudConfig = @"
    [CloudbaseInit]
    plugins=cloudbaseinit.plugins.windows.sethostname.SetHostNamePlugin,cloudbaseinit.plugins.common.sshpublickeys.SetUserSSHPublicKeysPlugin,cloudbaseinit.plugins.windows.createuser.CreateUserPlugin,cloudbaseinit.plugins.windows.extendvolumes.ExtendVolumesPlugin,cloudbaseinit.plugins.windows.winrmcertificateauth.CertificateAuthPlugin,cloudbaseinit.plugins.common.fileexec.FileExecPlugin,cloudbaseinit.plugins.windows.networkconfig.NetworkConfigPlugin,cloudbaseinit.plugins.windows.ntpclient.NtpClientPlugin
    verbose=true
    debug=true
    username=Administrator
    groups=Administrators
    inject_user_password=true
    bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
    ntp_use_short_format=false
    ntp_use_bundled_clock=true
    ntp_servers=pool.ntp.org
    ntp_retry_count=3
    ntp_retry_interval=10
    ntp_peer_delay=30
    ntp_peer_timeout=10
    bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
    bsdtar_timeout=10
    bsdtar_dest_folder=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\etc
    bsdtar_cacert_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\etc\pki\cacert.pem
    bsdtar_user_agent=Cloudbase-Init-UserAgent
    logdir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log
    logfile=cloudbase-init.log
    delete_ssh_keys=false
    bsdtar_timeout=300
    bsdtar_dest_folder=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\etc
    bsdtar_cacert_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\etc\pki\cacert.pem
    bsdtar_user_agent=Cloudbase-Init-UserAgent
    bsdtar_log_file=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\bsdtar.log
    bsdtar_log_level=DEBUG
    logrotate=true
    logfile_maxsize=10
    logfile_backup_count=5
    retry_count=5
    retry_count_retry_interval=10
    retry_delay=1
    ntp_use_bundled_clock=true
    proxy=None
    "@ 
    
    # Cloudbase-init Konfiguration in die VM kopieren
    Set-Content -Path "$VMPath\cloud-config.txt" -Value $CloudConfig
    
    # Cloudbase-init starten
    Invoke-Command -VMName $VMName -ScriptBlock {
        # Cloudbase-init installieren
        msiexec /i "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\cloudbase-init-setup-1.1.0-x64.msi" /qn /L*v C:\Windows\Temp\cloudbase-init-setup.log
    
        # Cloudbase-init konfigurieren
        C:\Program Files\Cloudbase Solutions\Cloudbase-Init\Python\Scripts\cloudbase-init.exe --config-file=C:\cloud-config.txt --install
    }
    
    Write-Host "Die virtuelle Maschine '$VMName' wurde erstellt und Cloudbase-init wird konfiguriert."

