# Domain Update Script
# This script updates all domain references to use hoodamath-games.github.io

Write-Host "Starting domain update process..."

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
        
        # Add canonical URL if not present (for main pages)
        if ($file.Name -eq "index.html" -and !$content.Contains('rel="canonical"')) {
            $content = $content -replace '(<link rel="shortcut icon"[^>]*>)', ('$1' + "`n" + '    <link rel="canonical" href="https://hoodamath-games.github.io/" />')
        }
        
        # Update JSON-LD schema URLs to use absolute URLs
        $content = $content -replace '"url":"\./', '"url":"https://hoodamath-games.github.io/'
        $content = $content -replace '"logo":"\./', '"logo":"https://hoodamath-games.github.io/'
        
        # Add Open Graph meta tags if not present
        if (!$content.Contains('property="og:url"')) {
            $pageUrl = "https://hoodamath-games.github.io/"
            if ($file.Name -ne "index.html") {
                $pageUrl = "https://hoodamath-games.github.io/$($file.Name)"
            }
            
            $ogTags = @"
    <meta property="og:url" content="$pageUrl" />
    <meta property="og:type" content="website" />
    <meta property="og:title" content="Unblocked Games" />
    <meta property="og:description" content="Play unblocked games online. Join our community of free online games and become a passionate gamer!" />
    <meta property="og:image" content="https://hoodamath-games.github.io/media/website/logo.webp" />
"@
            
            $content = $content -replace '(<meta name="description"[^>]*>)', ('$1' + "`n" + $ogTags)
        }
        
        # Add Twitter Card meta tags if not present
        if (!$content.Contains('name="twitter:card"')) {
            $pageUrl = "https://hoodamath-games.github.io/"
            if ($file.Name -ne "index.html") {
                $pageUrl = "https://hoodamath-games.github.io/$($file.Name)"
            }
            
            $twitterTags = @"
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:url" content="$pageUrl" />
    <meta name="twitter:title" content="Unblocked Games" />
    <meta name="twitter:description" content="Play unblocked games online. Join our community of free online games and become a passionate gamer!" />
    <meta name="twitter:image" content="https://hoodamath-games.github.io/media/website/logo.webp" />
"@
            
            $content = $content -replace '(<meta property="og:image"[^>]*>)', ('$1' + "`n" + $twitterTags)
        }
        
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

Write-Host "`nDomain update completed! Processed $processedCount files."
Write-Host "`nSummary of updates:"
Write-Host "- Updated JSON-LD schema URLs to use absolute URLs with hoodamath-games.github.io"
Write-Host "- Added canonical URLs where missing"
Write-Host "- Added Open Graph meta tags for social media sharing"
Write-Host "- Added Twitter Card meta tags for Twitter sharing"
Write-Host "`nYour website is now configured for deployment on hoodamath-games.github.io"
