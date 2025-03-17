$backupFile = "$env:TEMP\terminal_backup.ansi"
$ansiOutput = @()
$reader = [System.IO.StreamReader]::new([System.Console]::OpenStandardInput())
while ($reader.Peek() -ne -1) {
  $ansiOutput += $reader.ReadLine()
}
$ansiOutput -join "`n" | Set-Content -Path $backupFile -Encoding utf8
Write-Host "Écran sauvegardé dans $backupFile"

$r = [System.Management.Automation.Host.Rectangle]::new(0, 0, $Global:Host.UI.RawUI.BufferSize.Width, $Global:Host.UI.RawUI.BufferSize.Height)