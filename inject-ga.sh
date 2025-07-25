#!/bin/bash

# Define the GA snippet as a heredoc (multiline safe)
read -r -d '' GA_SNIPPET << EOM
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-0LCBV9FLHN"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag("js", new Date());

  gtag("config", "G-0LCBV9FLHN");
</script>
EOM

# Process all .html files recursively
find . -type f -name "*.html" | while read -r file; do
  if grep -q "</head>" "$file"; then
    echo "Injecting into $file"

    # Step 1: Remove any existing snippet (based on known unique GA script URL)
    # Save a clean copy before reinjecting
    sed '/<script async src="https:\/\/www.googletagmanager.com\/gtag\/js?id=G-0LCBV9FLHN"><\/script>/,/<\/script>/d' "$file" > "$file.clean"

    # Step 2: Re-inject snippet before </head>
    awk -v snippet="$GA_SNIPPET" '
    {
      if (match($0, /<\/head>/)) {
        head_pos = index($0, "</head>")
        print substr($0, 1, head_pos - 1)
        print snippet
        print substr($0, head_pos)
      } else {
        print
      }
    }' "$file.clean" > "$file" && rm "$file.clean"

  else
    echo "Skipping $file (no </head> tag found)"
  fi
done

echo "✅ Injection complete, old snippets removed!"

