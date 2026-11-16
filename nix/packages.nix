# The web site, built with Dart 2 (build_runner) from uttt_website and
# uttt_package. The NixOS module reaches it with withSystem
# (services/slaputtt/default.nix).
{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    pkgsDart2 = inputs.nixpkgs-dart2.legacyPackages.${system};
    projectRoot = ../.;

    combinedSrc = pkgs.stdenv.mkDerivation {
      name = "slaputtt-combined-src";
      src = lib.cleanSource projectRoot;
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        mkdir -p $out
        cp -r uttt_website $out/
        cp -r uttt_package $out/
        cp -r third_party $out/
      '';
    };

    pubCache = pkgs.stdenv.mkDerivation {
      name = "slaputtt-pub-cache";
      src = combinedSrc;

      nativeBuildInputs = [
        pkgsDart2.dart
        pkgs.cacert
        pkgs.findutils
        pkgs.coreutils
      ];

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      # Update when the pubspec dependencies change.
      outputHash = "sha256-DPPZwUpGoNQUbCNigKRFEq1zwuZYNlqhWzuGsWDJ2GQ=";

      buildPhase = ''
        export PUB_CACHE=$out
        export DART_VM_OPTIONS="--root-certs-file=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        export HOME=$TMPDIR
        cp -r $src work
        chmod -R u+w work
        cd work

        dart --root-certs-file="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" \
          pub get --directory=uttt_website

        echo "Normalizing pub cache for deterministic builds..."
        # Dart writes "_fetchedAt" timestamps in .cache/*-versions.json
        rm -rf "$out/hosted/pub.dev/.cache" || true
        rm -rf "$out/.cache" || true
      '';
      dontFixup = true;

      installPhase = "true";
    };

    slaputttWeb = pkgs.stdenv.mkDerivation {
      pname = "slaputtt-web";
      version = "0.1.0";
      src = combinedSrc;

      nativeBuildInputs = [
        pkgsDart2.dart
      ];

      buildPhase = ''
        export PATH=${lib.makeBinPath [pkgsDart2.dart]}:$PATH
        export PUB_CACHE=${pubCache}
        export HOME=$TMPDIR

        cp -r $src work
        chmod -R u+w work
        cd work

        dart pub get --offline --directory=uttt_website

        cd uttt_website
        dart run build_runner build --release -o build

        rm -f build/web/packages || true
        cd ../..
      '';

      installPhase = ''
        mkdir -p $out
        cp -r work/uttt_website/build/web/. $out/
      '';
    };
  in {
    packages.pub = pubCache;
    packages.web = slaputttWeb;
    packages.default = slaputttWeb;
  };
}
