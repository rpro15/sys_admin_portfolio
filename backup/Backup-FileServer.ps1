[CmdletBinding()]
param(
    [Parameter()]
    [string[]]$IncludeVolumes = @("C:", "D:"),

    [Parameter()]
    [string]$BackupTarget = "E:",

    [Parameter()]
    [string]$LogPath = ".\backup\backup-log.txt"
)

if (-not (Get-Command wbadmin -ErrorAction SilentlyContinue)) {
    throw "wbadmin is not available. Install Windows Server Backup feature first."
}

$includeArgument = ($IncludeVolumes -join ",")

Start-Transcript -Path $LogPath -Append

try {
    Write-Host "Starting backup to $BackupTarget for volumes: $includeArgument" -ForegroundColor Cyan

    & wbadmin start backup "-backupTarget:$BackupTarget" "-include:$includeArgument" -allCritical -quiet

    Write-Host "Backup completed. Recent versions:" -ForegroundColor Green
    & wbadmin get versions
}
catch {
    Write-Error "Backup failed: $($_.Exception.Message)"
    throw
}
finally {
    Stop-Transcript
}
