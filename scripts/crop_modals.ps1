Add-Type -AssemblyName System.Drawing

$modalOnline = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225099_c119af34.jpg"
$modalParty  = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225106_87337e6c.jpg"
$modalBots   = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225099_7ff42929.jpg"
$gameScreen  = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded\media_1794468225099_f64b0e80.jpg"

$outDir = "C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter\assets\extracted_modals"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force }

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

# The modal in all 3 images:
# Looking at the modal:
# It starts around x=270 to x=750 (width ~ 480)
# Height: with top characters and ribbon from y=50 to y=520 (height ~ 470)
Crop-File $modalOnline 270 50 490 470 "modal_online_full.png"
Crop-File $modalParty  270 50 490 470 "modal_party_full.png"
Crop-File $modalBots   270 50 490 470 "modal_bots_full.png"

# Gameplay Screen extractions:
$gameDir = "C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter\assets\extracted_game"
if (-not (Test-Path $gameDir)) { New-Item -ItemType Directory -Path $gameDir -Force }

# 1. Full table area with crates & opponents
# 2. Sidebar
# 3. Player dock
# Let's save the full game screen as high-res reference and components!
$imgGame = [System.Drawing.Image]::FromFile($gameScreen)
$bmpGame = New-Object System.Drawing.Bitmap($imgGame)
$bmpGame.Save((Join-Path $gameDir "gameplay_reference_board.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$bmpGame.Dispose()
$imgGame.Dispose()

Write-Output "Extracted modals and game board reference."
