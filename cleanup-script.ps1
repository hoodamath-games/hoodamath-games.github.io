# Website Cleanup Script
# This script removes all FreezeNova branding and original site references

Write-Host "Starting website cleanup process..."

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -Recurse
Write-Host "Found $($htmlFiles.Count) HTML files to process"

$processedCount = 0
$totalFiles = $htmlFiles.Count

foreach ($file in $htmlFiles) {
    $processedCount++
    Write-Progress -Activity "Cleaning HTML files" -Status "Processing $($file.Name)" -PercentComplete (($processedCount / $totalFiles) * 100)
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Remove HTTrack comments
        $content = $content -replace '<!-- Mirrored from unblocked-games\.s3\.amazonaws\.com.*?-->', ''
        
        # Remove advertising scripts
        $content = $content -replace '(?s)<script type="text/javascript" async>.*?wgplayer\.com.*?</script>', ''
        $content = $content -replace '<!-- Google tag \(gtag\.js\) -->', ''

        # Remove domain-specific JavaScript
        $content = $content -replace '(?s)<script>.*?freezenova\.github\.io.*?</script>', ''
        $content = $content -replace '(?s)<script>.*?allowedDomains.*?</script>', ''
        
        # Update titles and meta descriptions
        $content = $content -replace 'Unblocked Games FreezeNova', 'Unblocked Games'
        $content = $content -replace 'FreezeNova', 'Gaming Site'
        $content = $content -replace 'freezenova', 'gaming-site'
        
        # Update logo references
        $content = $content -replace 'unblocked-games-freezenova-logo\.webp', 'logo.webp'
        
        # Remove external links
        $content = $content -replace '<a href="https://freezenova\.blog/".*?</a>', ''
        $content = $content -replace '<a href="https://www\.youtube\.com/@freezenova".*?</a>', ''
        $content = $content -replace '<a href="https://github\.com/freezenova/freezenova\.github\.io".*?</a>', ''
        
        # Update alt text and titles
        $content = $content -replace 'alt="FreezeNova ([^"]*)"', 'alt="$1"'
        $content = $content -replace 'title="FreezeNova ([^"]*)"', 'title="$1"'
        $content = $content -replace 'alt="Unblocked Games FreezeNova"', 'alt="Unblocked Games"'
        
        # Update JSON-LD schema
        $content = $content -replace '"name":"Unblocked Games FreezeNova"', '"name":"Unblocked Games"'
        $content = $content -replace '"Unblocked Games FreezeNova"', '"Unblocked Games"'
        
        # Remove contact email
        $content = $content -replace 'contact@freezenova\.com', ''
        $content = $content -replace 'Email us at\s*<br>', '<br>'
        
        # Clean up extra whitespace and empty lines
        $content = $content -replace '\r?\n\s*\r?\n\s*\r?\n', "`n`n"
        
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

Write-Host "`nCleanup completed! Processed $processedCount files."
Write-Host "Next steps:"
Write-Host "1. Replace the logo file: media/website/unblocked-games-freezenova-logo.webp with your own logo.webp"
Write-Host "2. Update any remaining content references manually"
Write-Host "3. Test the site functionality"
