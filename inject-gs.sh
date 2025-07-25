#!/bin/bash

# Define the Google Analytics snippet
GA_SNIPPET='<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-0LCBV9FLHN"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag("js", new Date());

  gtag("config", "G-0LCBV9FLHN");
</script>'

# Loop through all .html files and insert the snippet before </head>
find . -type f -name "*.html" | while read file; do
  if grep -q "</head>" "$file"; then
    echo "Injecting into $file"
    # Use sed to insert before </head>
    sed -i.bak "/<\/head>/i $GA_SNIPPET" "$file"
  else
    echo "Skipping $file (no </head> tag found)"
  fi
done

echo "Done!"
