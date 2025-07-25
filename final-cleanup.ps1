# Final Cleanup Script
# This script addresses remaining issues from the cleanup process

Write-Host "Performing final cleanup..."

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -Recurse
Write-Host "Found $($htmlFiles.Count) HTML files to clean"

$processedCount = 0
$totalFiles = $htmlFiles.Count

foreach ($file in $htmlFiles) {
    $processedCount++
    Write-Progress -Activity "Final cleanup" -Status "Processing $($file.Name)" -PercentComplete (($processedCount / $totalFiles) * 100)
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        
        # Remove broken external links
        $content = $content -replace '<a href="https://Gaming Site\.blog/"[^>]*>.*?</a>', ''
        $content = $content -replace '<a href="https://www\.youtube\.com/@Gaming Site"[^>]*>.*?</a>', ''
        $content = $content -replace '<a href="https://github\.com/Gaming Site/[^"]*"[^>]*>.*?</a>', ''
        
        # Fix any remaining "Gaming Site" references in URLs
        $content = $content -replace 'Gaming Site\.blog', ''
        $content = $content -replace '@Gaming Site', ''
        $content = $content -replace 'github\.com/Gaming Site', ''
        
        # Remove empty list items that might have been created
        $content = $content -replace '<li>\s*</li>', ''
        $content = $content -replace '<li[^>]*>\s*</li>', ''
        
        # Clean up any remaining "Gaming Site" in content that should be generic
        $content = $content -replace 'Who made Gaming Site\?', 'About the Platform'
        $content = $content -replace 'Gaming Site was invented by', 'This platform was created by'
        $content = $content -replace 'Gaming Site as a brand', 'this platform as a brand'
        
        # Remove specific developer attribution that's tied to the original site
        $content = $content -replace '<a href="https://www\.linkedin\.com/in/cristian-ovidiu-marin/"[^>]*>.*?</a>', 'the development team'
        $content = $content -replace '<a href="https://www\.youtube\.com/watch\?v=ilcAuZ04BHs"[^>]*>.*?</a>', 'various games'
        $content = $content -replace '<a href="https://www\.linkedin\.com/company/Gaming Site/"[^>]*>.*?</a>', 'our company'
        
        # Clean up extra whitespace
        $content = $content -replace '\s+', ' '
        $content = $content -replace '>\s+<', '><'
        
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

Write-Host "`nFinal cleanup completed! Processed $processedCount files."
Write-Host "`nSummary of cleanup completed:"
Write-Host "- Removed advertising scripts (wgplayer.com)"
Write-Host "- Removed Google Analytics placeholders"
Write-Host "- Updated all FreezeNova branding to generic terms"
Write-Host "- Fixed logo references to point to logo.webp"
Write-Host "- Removed external service integrations (Disqus, YouTube, GitHub)"
Write-Host "- Cleaned up schema markup and meta tags"
Write-Host "- Removed HTTrack mirroring comments"
Write-Host "- Updated alt text and titles"
Write-Host "- Removed contact information and developer attribution"
Write-Host "`nRemaining tasks:"
Write-Host "1. Replace media/website/unblocked-games-freezenova-logo.webp with your own logo.webp"
Write-Host "2. Update any game-specific content as needed"
Write-Host "3. Test the website functionality"
Write-Host "4. Deploy to your domain"
