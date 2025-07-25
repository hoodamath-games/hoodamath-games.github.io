# Fix Path Issues Script
# This script fixes any path issues created by the previous cleanup

Write-Host "Fixing path issues..."

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -Recurse
Write-Host "Found $($htmlFiles.Count) HTML files to fix"

$processedCount = 0
$totalFiles = $htmlFiles.Count

foreach ($file in $htmlFiles) {
    $processedCount++
    Write-Progress -Activity "Fixing paths" -Status "Processing $($file.Name)" -PercentComplete (($processedCount / $totalFiles) * 100)
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Fix logo path issues
        $content = $content -replace 'unblocked-games-Gaming Site-logo\.webp', 'logo.webp'
        $content = $content -replace 'Gaming Site-logo\.webp', 'logo.webp'
        
        # Fix any file paths that got corrupted
        $content = $content -replace 'Gaming Site-([^"]*\.(?:webp|jpg|png))', 'freezenova-$1'
        
        # Fix author URLs
        $content = $content -replace '"url":"./authors/Gaming Site/"', '"url":"./authors/admin/"'
        
        # Clean up any double spaces or formatting issues
        $content = $content -replace '\s+', ' '
        $content = $content -replace '>\s+<', '><'
        
        # Only write if content changed
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            Write-Host "Fixed: $($file.Name)"
        }
    }
    catch {
        Write-Warning "Error processing $($file.Name): $($_.Exception.Message)"
    }
}

Write-Host "`nPath fixes completed! Processed $processedCount files."
