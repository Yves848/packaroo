# check is dependecies are installed.

if ((Get-Module Microsoft.Winget.Client -ListAvailable).Count -eq 0) {
  # Microsoft.Winget.Client not installed
}

if ((Get-Module PwshSpectreConsole -ListAvailable).Count -eq 0) {
  # pwshSpectreConsole not installed
}

Import-Module Microsoft.WinGet.Client
Import-Module PwshSpectreConsole
