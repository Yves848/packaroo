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

$Script:width = $global:host.UI.RawUI.BufferSize.Width
$Script:height = $global:host.UI.RawUI.BufferSize.Height

$Script:headers = @("", "Name", "Id", "Version", "Source")
$script:gh = 0 # grid height
$script:listTop = 0 # first position of the grid
$script:columns = New-Object 'System.Collections.Generic.List[PSCustomObject]'
class Pack {
  [string]$name
  [string]$id
  [string]$version
  [string]$source
  [string]$scoopsource
  [bool]$majavail

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
    $this.majavail = $false
  }
}

class GridLine {
  [bool]$selected
  [Pack]$packInfo
  [int]$action
}

$script:theme = @{
  "Rosewater" = @{ R = 245; G = 224; B = 220 }
  "Flamingo"  = @{ R = 242; G = 205; B = 205 }
  "Pink"      = @{ R = 245; G = 194; B = 231 }
  "Mauve"     = @{ R = 203; G = 166; B = 247 }
  "Red"       = @{ R = 243; G = 139; B = 168 }
  "Maroon"    = @{ R = 235; G = 160; B = 172 }
  "Peach"     = @{ R = 250; G = 179; B = 135 }
  "Yellow"    = @{ R = 249; G = 226; B = 175 }
  "Green"     = @{ R = 166; G = 227; B = 161 }
  "Teal"      = @{ R = 148; G = 226; B = 213 }
  "Sky"       = @{ R = 137; G = 220; B = 235 }
  "Sapphire"  = @{ R = 116; G = 199; B = 236 }
  "Blue"      = @{ R = 137; G = 180; B = 250 }
  "Lavender"  = @{ R = 180; G = 190; B = 254 }
  "Text"      = @{ R = 205; G = 214; B = 244 }
  "SubText1"  = @{ R = 186; G = 194; B = 222 }
  "SubText0"  = @{ R = 166; G = 173; B = 200 }
  "Overlay2"  = @{ R = 147; G = 153; B = 178 }
  "Overlay1"  = @{ R = 127; G = 132; B = 156 }
  "Overlay0"  = @{ R = 108; G = 112; B = 134 }
  "Surface2"  = @{ R = 88; G = 91; B = 112 }
  "Surface1"  = @{ R = 69; G = 71; B = 90 }
  "Surface0"  = @{ R = 49; G = 50; B = 68 }
  "Base"      = @{ R = 30; G = 30; B = 46 }
  "Mantle"    = @{ R = 24; G = 24; B = 37 }
  "Crust"     = @{ R = 17; G = 17; B = 27 }
}