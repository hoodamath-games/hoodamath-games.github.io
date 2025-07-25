# Final Final Cleanup Script
# This script addresses the remaining "Gaming Site" references

Write-Host "Performing final final cleanup..."

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -Recurse
Write-Host "Found $($htmlFiles.Count) HTML files to clean"

$processedCount = 0
$totalFiles = $htmlFiles.Count

foreach ($file in $htmlFiles) {
    $processedCount++
    Write-Progress -Activity "Final final cleanup" -Status "Processing $($file.Name)" -PercentComplete (($processedCount / $totalFiles) * 100)
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Remove remaining "Gaming Site" references
        $content = $content -replace 'Gaming Site', 'Our Platform'
        $content = $content -replace 'https://Gaming Site\.blog/', ''
        $content = $content -replace 'https://www\.youtube\.com/@Gaming Site', ''
        $content = $content -replace 'href="https://Gaming Site\.blog/"[^>]*>', 'href="#"'
        $content = $content -replace 'href="https://www\.youtube\.com/@Gaming Site"[^>]*>', 'href="#"'
        
        # Clean up broken links
        $content = $content -replace '<a href="#">[^<]*</a>', ''
        $content = $content -replace '<a href=""[^>]*>[^<]*</a>', ''
        
        # Remove empty list items
        $content = $content -replace '<li><a href="#">[^<]*</a></li>', ''
        $content = $content -replace '<li></li>', ''
        
        # Only write if content changed
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            Write-Host "Cleaned: $($file.Name)"
        }
    }
    catch {
        Write-Warning "Error processing $($file.Name): $($_.Exception.Message)"
    }
}

Write-Host "`nFinal final cleanup completed! Processed $processedCount files."
