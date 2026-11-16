set dotenv-load := false

default:
  @just --list

# Launch the website on localhost (live dev server)
launch:
  cd uttt_website && dart pub get && dart run build_runner serve

# Run tests for uttt_package
test:
  cd uttt_package && dart pub get && dart test

# Format nix files
format:
  nix fmt

# Check the flake
check:
  nix flake check

# Download the third-party scripts, styles and icon font into uttt_website/web/vendor
# (pinned versions; the pages load them from this server, not from CDNs)
vendor:
  #!/usr/bin/env bash
  set -euo pipefail
  dir=uttt_website/web/vendor
  mkdir -p "$dir"
  curl -fsSL -o "$dir/materialize.min.css" https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css
  curl -fsSL -o "$dir/materialize.min.js" https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js
  curl -fsSL -o "$dir/Chart.bundle.min.js" https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.bundle.min.js
  curl -fsSL -o "$dir/d3.min.js" https://cdn.jsdelivr.net/npm/d3@7.9.0/dist/d3.min.js
  curl -fsSL -o "$dir/material-icons.woff2" https://cdn.jsdelivr.net/npm/material-icons@1.13.14/iconfont/material-icons.woff2
  curl -fsSL -o "$dir/roboto-latin-400.woff2" https://cdn.jsdelivr.net/npm/@fontsource/roboto@5.1.0/files/roboto-latin-400-normal.woff2
  curl -fsSL https://cdn.jsdelivr.net/npm/material-icons@1.13.14/iconfont/filled.css \
    | sed 's|, url("./material-icons.woff") format("woff")||' > "$dir/material-icons.css"
