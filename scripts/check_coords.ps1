Add-Type -AssemblyName System.Drawing

$gamePath = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225099_f64b0e80.jpg"
$img = [System.Drawing.Image]::FromFile($gamePath)
Write-Output "Image size: $($img.Width) x $($img.Height)"

# In 1024 x 571:
# The bottom cards tray is at the bottom center:
# y should be around y=410 to y=560!
# The crates are at center y=200 to y=350!
$img.Dispose()
