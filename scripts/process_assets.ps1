Add-Type -AssemblyName System.Drawing

$mediaDir = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded"
$images = Get-ChildItem -Path $mediaDir -Filter "*.jpg"

foreach ($f in $images) {
    $img = [System.Drawing.Image]::FromFile($f.FullName)
    Write-Output "$($f.Name): $($img.Width)x$($img.Height)"
    $img.Dispose()
}
