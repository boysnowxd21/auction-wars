Add-Type -AssemblyName System.Drawing

$modalOnline = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225099_c119af34.jpg"
$modalParty  = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225106_87337e6c.jpg"
$modalBots   = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225099_7ff42929.jpg"
$outDir      = "C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter\assets\extracted_modals"

function Crop-File($srcFile, $x, $y, $w, $h, $name) {
    $img = [System.Drawing.Image]::FromFile($srcFile)
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    
    $srcRect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $destRect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
    $g.DrawImage($img, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    
    $savePath = Join-Path $outDir $name
    $bmp.Save($savePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    $img.Dispose()
    Write-Output "Saved: $name ($w x $h)"
}

# 1. Online Modal:
Crop-File $modalOnline 335 45 350 145 "online_top_header.png"
Crop-File $modalOnline 360 385 295 75 "online_btn_quickmatch.png"
Crop-File $modalOnline 690 100 58 58 "modal_btn_close.png"

# 2. Local Party Modal:
Crop-File $modalParty 335 45 350 145 "party_top_header.png"
Crop-File $modalParty 360 385 295 75 "party_btn_host.png"

# 3. Bots Arena Modal:
Crop-File $modalBots 315 45 390 145 "bots_top_header.png"
Crop-File $modalBots 335 250 105 130 "diff_card_easy.png"
Crop-File $modalBots 445 250 105 130 "diff_card_medium.png"
Crop-File $modalBots 555 250 105 130 "diff_card_kingpin.png"
Crop-File $modalBots 355 385 300 75 "bots_btn_start.png"

Write-Output "Modal assets cropped successfully."
