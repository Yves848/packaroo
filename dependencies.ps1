# check is dependecies are installed.

if ((Get-Module Microsoft.Winget.Client -ListAvailable).Count -eq 0) {
  # Microsoft.Winget.Client not installed
}

if ((Get-Module PwshSpectreConsole -ListAvailable).Count -eq 0) {
  # pwshSpectreConsole not installed
}

$global:scoop = $env:path -match "scoop"

Import-Module Microsoft.WinGet.Client
Import-Module PwshSpectreConsole

$width = $global:host.UI.RawUI.BufferSize.Width
$height = $global:host.UI.RawUI.BufferSize.Height

$headers = @("","Name","Id","Version","Source")
$script:gh = 0 # grid height

class Pack {
  [string]$name
  [string]$id
  [string]$version
  [string]$source
  [string]$scoopsource

  Pack(
    [string]$Name,
    [string]$Id,
    [string]$Version,
    [string]$Source,
    [string]$scoopsource = ""
  ) {
    $this.id = $Id
    $this.name = $Name
    $this.source = $source
    $this.version = $version
    $this.scoopsource = $scoopsource
  }
}

class Line {
  [bool]$selected
  [Pack]$package
}