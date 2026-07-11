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
