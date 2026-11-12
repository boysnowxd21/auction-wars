Add-Type -AssemblyName System.Drawing

function Crop-CardFile($filePath) {
    try {
        $bmp = [System.Drawing.Bitmap]::FromFile($filePath)
        $w = $bmp.Width
        $h = $bmp.Height
        $minX = $w
        $maxX = 0
        $minY = $h
        $maxY = 0

        # Scan for non-transparent pixels with step of 2 for speed
        for ($y = 0; $y -lt $h; $y += 2) {
            for ($x = 0; $x -lt $w; $x += 2) {
                if ($bmp.GetPixel($x, $y).A -gt 15) {
                    if ($x -lt $minX) { $minX = $x }
                    if ($x -gt $maxX) { $maxX = $x }
                    if ($y -lt $minY) { $minY = $y }
                    if ($y -gt $maxY) { $maxY = $y }
                }
            }
        }

        # If bounding box found and smaller than image
        if ($maxX -gt $minX -and $maxY -gt $minY) {
            # Add small 2px margin if within bounds
            $minX = [Math]::Max(0, $minX - 2)
            $minY = [Math]::Max(0, $minY - 2)
            $maxX = [Math]::Min($w - 1, $maxX + 2)
            $maxY = [Math]::Min($h - 1, $maxY + 2)

            $cropW = $maxX - $minX + 1
            $cropH = $maxY - $minY + 1

            # Only crop if there was significant margin (at least 20px difference)
            if ($cropW -lt ($w - 20) -or $cropH -lt ($h - 20)) {
                $rect = [System.Drawing.Rectangle]::new($minX, $minY, $cropW, $cropH)
                $cropped = $bmp.Clone($rect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
                $bmp.Dispose()
                
                # Save to temp then replace
                $tempPath = $filePath + ".tmp.png"
                $cropped.Save($tempPath, [System.Drawing.Imaging.ImageFormat]::Png)
                $cropped.Dispose()

                Move-Item -Path $tempPath -Destination $filePath -Force
                return "$([System.IO.Path]::GetFileName($filePath)): ${w}x${h} -> ${cropW}x${cropH}"
            }
        }
        $bmp.Dispose()
        return "$([System.IO.Path]::GetFileName($filePath)): already tight"
    } catch {
        return "Error on $filePath : $_"
    }
}

$cardsDir = "C:\Users\HP\.gemini\antigravity\scratch\auction_wars_flutter\assets\cards"
$files = Get-ChildItem -Path $cardsDir -Filter "*.png"
$count = 0
foreach ($f in $files) {
    $res = Crop-CardFile $f.FullName
    $count++
    if ($count % 20 -eq 0) {
        Write-Host "Processed $count of $($files.Count)..."
    }
}
Write-Host "Completed cropping all $($files.Count) cards!"
