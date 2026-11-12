Add-Type -AssemblyName System.Drawing

$sourcePath = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225116_7f1ddc43.jpg"
$outDir = "C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter\assets\extracted_home"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force }

$img = [System.Drawing.Image]::FromFile($sourcePath)

function Crop-Image($x, $y, $w, $h, $name) {
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
    Write-Output "Saved: $name ($w x $h)"
}

# Image is 1024 x 571
# Top bar:
# Leaderboard: around x=10, y=10, w=90, h=90
Crop-Image 12 12 90 90 "medallion_leaderboard.png"
# Settings: around x=922, y=12, w=90, h=90
Crop-Image 920 12 92 90 "medallion_settings.png"
# AUCTION WARS Title Logo + Gavel: x=350, y=10, w=390, h=145
Crop-Image 350 10 390 145 "logo_auction_wars.png"

# Mode Cards:
# Card 1 (Online Play): x=98, y=158, w=272, h=250
Crop-Image 98 158 272 250 "card_online_play.png"
# Card 2 (Local Party): x=382, y=158, w=272, h=250
Crop-Image 382 158 272 250 "card_local_party.png"
# Card 3 (VS Bots Arena): x=668, y=158, w=272, h=250
Crop-Image 668 158 272 250 "card_vs_bots.png"

# Bottom Elements:
# Bidders Bottom-Left: x=0, y=410, w=290, h=161
Crop-Image 0 410 290 161 "bidders_bottom_left.png"
# Compendium Banner: x=336, y=438, w=354, h=98
Crop-Image 336 438 354 98 "banner_compendium.png"
# Auctioneer Bottom-Right: x=800, y=410, w=224, h=161
Crop-Image 800 410 224 161 "auctioneer_bottom_right.png"

$img.Dispose()
Write-Output "Done cropping Home Screen components."
