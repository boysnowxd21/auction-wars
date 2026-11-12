$srcDir = "C:\Users\HP\.gemini\antigravity\brain\04b15948-7b82-4217-bdad-d529dc93d0b0\.user_uploaded"
$destDir = "C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter\assets\reference"
if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force }

Copy-Item (Join-Path $srcDir "media_1794468225116_7f1ddc43.jpg") (Join-Path $destDir "ref_home.jpg") -Force
Copy-Item (Join-Path $srcDir "media_1794468225099_f64b0e80.jpg") (Join-Path $destDir "ref_game.jpg") -Force
Copy-Item (Join-Path $srcDir "media_1794468225099_c119af34.jpg") (Join-Path $destDir "ref_modal_online.jpg") -Force
Copy-Item (Join-Path $srcDir "media_1794468225106_87337e6c.jpg") (Join-Path $destDir "ref_modal_party.jpg") -Force
Copy-Item (Join-Path $srcDir "media_1794468225099_7ff42929.jpg") (Join-Path $destDir "ref_modal_bots.jpg") -Force

Write-Output "Copied 5 reference images into assets/reference/"
