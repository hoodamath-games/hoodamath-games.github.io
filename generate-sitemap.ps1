# Sitemap Generator Script
# This script generates a comprehensive sitemap.xml for the unblocked games website

Write-Host "Generating sitemap.xml..."

$domain = "https://hoodamath-games.github.io"
$currentDate = Get-Date -Format "yyyy-MM-dd"

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -Recurse | Where-Object { 
    $_.Name -notlike "*game-developers*" -and 
    $_.DirectoryName -notlike "*\page\*" -and
    $_.Name -ne "index-2.html"
}

Write-Host "Found $($htmlFiles.Count) HTML files to include in sitemap"

# Start building the sitemap XML
$sitemap = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
"@

# Define priority and change frequency for different types of pages
function Get-PagePriority($fileName, $directory) {
    if ($fileName -eq "index.html" -and $directory -eq (Get-Location).Path) {
        return "1.0", "daily"
    }
    elseif ($fileName -eq "index.html") {
        return "0.8", "weekly"
    }
    elseif ($fileName -like "*new-games*" -or $fileName -like "*recently-played*") {
        return "0.9", "daily"
    }
    elseif ($fileName -like "*about*" -or $fileName -like "*contact*" -or $fileName -like "*privacy*") {
        return "0.3", "monthly"
    }
    else {
        return "0.7", "weekly"
    }
}

# Process each HTML file
foreach ($file in $htmlFiles) {
    $relativePath = $file.FullName.Replace((Get-Location).Path, "").Replace("\", "/").TrimStart("/")
    $url = "$domain/$relativePath"
    
    $priority, $changefreq = Get-PagePriority $file.Name $file.DirectoryName
    
    $sitemap += @"

    <url>
        <loc>$url</loc>
        <lastmod>$currentDate</lastmod>
        <changefreq>$changefreq</changefreq>
        <priority>$priority</priority>
    </url>
"@
}

# Close the sitemap XML
$sitemap += @"

</urlset>
"@

# Write the sitemap to file
Set-Content -Path "sitemap.xml" -Value $sitemap -Encoding UTF8

Write-Host "Sitemap generated successfully!"
Write-Host "Total URLs included: $($htmlFiles.Count)"
Write-Host "Sitemap saved as: sitemap.xml"
