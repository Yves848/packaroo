Add-Type @"
using System;
using System.Runtime.InteropServices;

public class WinAPI {
    [DllImport("user32.dll")]
    public static extern int ShowWindow(IntPtr hWnd, int nCmdShow);
    
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@




function maximize {
  # 3 = Maximiser la fenêtre
  $SW_MAXIMIZE = 3
  $hWnd = [WinAPI]::GetForegroundWindow()
  [WinAPI]::ShowWindow($hWnd, $SW_MAXIMIZE)
}

function restore {
  $SW_RESTORE = 9
  $hWnd = [WinAPI]::GetForegroundWindow()
  [WinAPI]::ShowWindow($hWnd, $SW_RESTORE)
}
