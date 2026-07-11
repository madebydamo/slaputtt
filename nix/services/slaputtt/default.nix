# Slaputtt service: build Dart web app and serve with nginx.
{
  inputs,
  lib,
  ...
}: let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  pkgsDart2 = inputs.nixpkgs-dart2.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  projectRoot = ../../../.;

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
    # Placeholder; updated after first successful build.
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
  perSystem = {...}: {
    packages.pub = pubCache;
    packages.web = slaputttWeb;
  };

  flake.modules.nixos.slaputtt = {
    config,
    lib,
    ...
  }: let
    cfg = config.neo.services.slaputtt;
  in {
    config = lib.mkIf cfg.enabled {
      services.nginx = {
        enable = true;
        virtualHosts."slaputtt.local" = {
          listen = [
            {
              addr = "0.0.0.0";
              port = cfg.port;
            }
          ];
          root = slaputttWeb;
          locations."/" = {
            tryFiles = "$uri $uri/ /index.html";
          };
        };
      };
    };
  };
}
