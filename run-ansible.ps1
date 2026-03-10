[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet("ping", "playbook")]
    [string]$Action = "playbook",

    [Parameter()]
    [string]$Inventory = "ansible/inventory.ini",

    [Parameter()]
    [string]$Playbook = "ansible/site.yml",

    [Parameter()]
    [string]$Target = "windows",

    [Parameter()]
    [string]$WinrmPassword,

    [Parameter()]
    [switch]$PromptPassword,

    [Parameter()]
    [switch]$VerboseOutput,

    [Parameter()]
    [switch]$DryRun
)

function Convert-ToWslPath {
    param([Parameter(Mandatory = $true)][string]$WindowsPath)

    $fullPath = [System.IO.Path]::GetFullPath($WindowsPath)
    $normalized = $fullPath -replace "\\", "/"

    if ($normalized -notmatch "^[A-Za-z]:/") {
        throw "Cannot convert path to WSL format: $WindowsPath"
    }

    $drive = $normalized.Substring(0, 1).ToLowerInvariant()
    $rest = $normalized.Substring(2)
    return "/mnt/$drive$rest"
}

$repoRoot = Split-Path -Parent $PSCommandPath
Set-Location -Path $repoRoot

if (-not $WinrmPassword) {
    $WinrmPassword = $env:WINRM_PASSWORD
}

if (-not $WinrmPassword -and $PromptPassword) {
    $securePassword = Read-Host "Enter WINRM password" -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    try {
        $WinrmPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
}

if (-not $WinrmPassword) {
    throw "WINRM password is required. Use -WinrmPassword, -PromptPassword, or set WINRM_PASSWORD environment variable."
}

$inventoryArg = ($Inventory -replace "\\", "/")
$playbookArg = ($Playbook -replace "\\", "/")
$verbosityArg = if ($VerboseOutput) { "-vv" } else { "" }
$wslRepoPath = Convert-ToWslPath -WindowsPath $repoRoot

if ($Action -eq "ping") {
    $ansibleCmd = "ansible -i '$inventoryArg' '$Target' -m ansible.windows.win_ping -e `"ansible_password=`$WINRM_PASSWORD`" $verbosityArg"
}
else {
    $ansibleCmd = "ansible-playbook -i '$inventoryArg' '$playbookArg' -e `"ansible_password=`$WINRM_PASSWORD`" $verbosityArg"
}

$bashCommand = "cd '$wslRepoPath' && $ansibleCmd"

if ($DryRun) {
    Write-Host "Dry run. Command that will be executed:" -ForegroundColor Yellow
    Write-Host "wsl bash -lc `"$bashCommand`""
    exit 0
}

Write-Host "Running via WSL: $Action" -ForegroundColor Cyan

$originalWinrmPassword = $env:WINRM_PASSWORD
try {
    $env:WINRM_PASSWORD = $WinrmPassword
    & wsl bash -lc $bashCommand
    $exitCode = $LASTEXITCODE
}
finally {
    if ($null -eq $originalWinrmPassword) {
        Remove-Item Env:WINRM_PASSWORD -ErrorAction SilentlyContinue
    }
    else {
        $env:WINRM_PASSWORD = $originalWinrmPassword
    }
}

if ($exitCode -ne 0) {
    throw "Command failed with exit code: $exitCode"
}

Write-Host "Done." -ForegroundColor Green
