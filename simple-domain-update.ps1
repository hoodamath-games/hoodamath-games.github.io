# Simple Domain Update Script
# This script updates essential domain references to use hoodamath-games.github.io

Write-Host "Starting simple domain update process..."

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -Recurse
Write-Host "Found $($htmlFiles.Count) HTML files to process"

$processedCount = 0
$totalFiles = $htmlFiles.Count

foreach ($file in $htmlFiles) {
    $processedCount++
    Write-Progress -Activity "Updating domain references" -Status "Processing $($file.Name)" -PercentComplete (($processedCount / $totalFiles) * 100)
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Update JSON-LD schema URLs to use absolute URLs
        $content = $content -replace '"url":"\./', '"url":"https://hoodamath-games.github.io/'
        $content = $content -replace '"logo":"\./', '"logo":"https://hoodamath-games.github.io/'
        
        # Only write if content changed
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            Write-Host "Updated: $($file.Name)"
        }
    }
    catch {
        Write-Warning "Error processing $($file.Name): $($_.Exception.Message)"
    }
}

Write-Host "`nSimple domain update completed! Processed $processedCount files."
Write-Host "Updated JSON-LD schema URLs to use absolute URLs with hoodamath-games.github.io"
