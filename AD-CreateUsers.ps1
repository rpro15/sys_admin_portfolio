[CmdletBinding()]
param(
    [Parameter()]
    [string]$CsvPath = ".\examples\users.csv",

    [Parameter()]
    [string]$HomeShareRoot = "\\FS01\Home$",

    [Parameter()]
    [string]$HomeFolderLocalRoot = "D:\Home",

    [Parameter()]
    [string]$HomeDrive = "H:",

    [Parameter()]
    [switch]$WhatIf
)

Import-Module ActiveDirectory

if (-not (Test-Path -Path $CsvPath)) {
    throw "CSV file not found: $CsvPath"
}

if (-not (Test-Path -Path $HomeFolderLocalRoot)) {
    New-Item -Path $HomeFolderLocalRoot -ItemType Directory -Force | Out-Null
}

$users = Import-Csv -Path $CsvPath

foreach ($user in $users) {
    $sam = $user.SamAccountName
    $upn = $user.UserPrincipalName
    $displayName = "$($user.GivenName) $($user.Surname)"
    $targetOu = $user.OU
    $homeDirShare = "$HomeShareRoot\$sam"
    $homeDirLocal = Join-Path -Path $HomeFolderLocalRoot -ChildPath $sam

    if ([string]::IsNullOrWhiteSpace($sam) -or [string]::IsNullOrWhiteSpace($upn) -or [string]::IsNullOrWhiteSpace($targetOu)) {
        Write-Warning "Skipping malformed row (missing SamAccountName/UserPrincipalName/OU)."
        continue
    }

    $existing = Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue
    if ($null -ne $existing) {
        Write-Host "User already exists: $sam" -ForegroundColor Yellow
        continue
    }

    $securePassword = ConvertTo-SecureString $user.Password -AsPlainText -Force

    $newUserParams = @{
        Name                  = $displayName
        GivenName             = $user.GivenName
        Surname               = $user.Surname
        DisplayName           = $displayName
        SamAccountName        = $sam
        UserPrincipalName     = $upn
        Path                  = $targetOu
        Department            = $user.Department
        Title                 = $user.Title
        AccountPassword       = $securePassword
        Enabled               = $true
        ChangePasswordAtLogon = $true
        HomeDirectory         = $homeDirShare
        HomeDrive             = $HomeDrive
        ErrorAction           = "Stop"
    }

    if ($WhatIf) {
        Write-Host "[WhatIf] Would create AD user: $sam"
    }
    else {
        New-ADUser @newUserParams
        Write-Host "Created AD user: $sam" -ForegroundColor Green
    }

    if (-not (Test-Path -Path $homeDirLocal)) {
        New-Item -Path $homeDirLocal -ItemType Directory -Force | Out-Null
    }

    # Apply least-privilege ACLs for the user home folder.
    $acl = Get-Acl -Path $homeDirLocal
    $acl.SetAccessRuleProtection($true, $false)

    foreach ($rule in @($acl.Access)) {
        $null = $acl.RemoveAccessRule($rule)
    }

    $userRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$env:USERDOMAIN\$sam", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $adminRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$env:USERDOMAIN\Domain Admins", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $systemRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

    $acl.AddAccessRule($userRule)
    $acl.AddAccessRule($adminRule)
    $acl.AddAccessRule($systemRule)

    if ($WhatIf) {
        Write-Host "[WhatIf] Would set ACL on: $homeDirLocal"
    }
    else {
        Set-Acl -Path $homeDirLocal -AclObject $acl
    }
}

Write-Host "Done. Processed $($users.Count) rows from $CsvPath" -ForegroundColor Cyan
