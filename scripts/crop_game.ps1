Add-Type -AssemblyName System.Drawing

$gamePath = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225099_f64b0e80.jpg"
$outDir = "C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter\assets\extracted_game"
$img = [System.Drawing.Image]::FromFile($gamePath)

function Crop-Game($x, $y, $w, $h, $name) {
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

# Crates
Crop-Game 240 215 365 125 "crates_center.png"

# Current Bid & bills
Crop-Game 630 250 150 140 "bid_pot_bills.png"

# Cards tray (X-Ray Specs, Skip Next Bidder, Discount Voucher)
Crop-Game 345 420 325 145 "ops_cards_dock.png"

# Separate individual ops cards:
Crop-Game 355 425 100 135 "card_xray_specs.png"
Crop-Game 455 425 100 135 "card_skip_bidder.png"
Crop-Game 555 425 100 135 "card_discount_voucher.png"

# Player dock:
Crop-Game 20 420 275 145 "player_you_dock.png"

# Felt table oval:
Crop-Game 0 50 855 520 "felt_table_area.png"

$img.Dispose()
Write-Output "Game screen components successfully cropped."
