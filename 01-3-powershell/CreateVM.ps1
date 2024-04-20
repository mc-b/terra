# Funktion zur Erstellung einer virtuellen Maschine in Hyper-V
function Create-VM {
    param (
        [string]$VMName,
        [string]$VHDPath,
        [string]$SwitchName
    )

    $VMPath = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\"
    $VHDFile = "$VMPath\$VMName.vhdx"
    $VM = New-VM -Name $VMName -Path $VMPath -NewVHDPath $VHDFile -NewVHDSizeBytes 20GB 
    Add-VMNetworkAdapter -VMName $VMName -SwitchName $SwitchName
}

# Funktion zur Ausführung eines PowerShell-Skripts in einer VM
function Execute-ScriptInVM {
    param (
        [string]$VMName,
        [string]$ScriptPath
    )

    $VM = Get-VM -Name $VMName
    $VM | Start-VM
    $VM | Get-VMConsole | Wait-VM
    $Session = New-PSSession -VMName $VMName
    Copy-Item -Path $ScriptPath -ToSession $Session -Destination "C:\"
    Invoke-Command -Session $Session -ScriptBlock { Invoke-Expression -Command "C:\$(Split-Path -Leaf $using:ScriptPath)" }
    Remove-PSSession -Session $Session
}

# Name der VM und des PowerShell-Skripts
$VMName = "TestVM"
$ScriptPath = "Install.ps1"
$boxPath = "C:\Users\Public\Documents\windows-10.box"   

# Erstelle die VM in Hyper-V
Create-VM -VMName $VMName -VHDPath "$VMName.vhdx" -SwitchName "Default Switch"

# Warte einige Sekunden, damit die VM vollständig gestartet ist
Start-Sleep -Seconds 30

# Führe das PowerShell-Skript in der VM aus
Execute-ScriptInVM -VMName $VMName -ScriptPath $ScriptPath
