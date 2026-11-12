Add-Type -AssemblyName System.Drawing

$dir = "C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter\assets\extracted_home"
Get-ChildItem $dir -Filter "*.png" | ForEach-Object {
    $img = [System.Drawing.Image]::FromFile($_.FullName)
    Write-Output "$($_.Name): $($img.Width)x$($img.Height)"
    $img.Dispose()
}
