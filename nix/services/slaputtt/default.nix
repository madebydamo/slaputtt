# Ultimate Tic Tac Toe: a static site served by the host nginx on loopback.
# SWAG reaches it through host.docker.internal (mkDockerToLocalhostForward).
{withSystem, ...}: {
  neoPlugin.modules.slaputtt = {
    config,
    lib,
    pkgs,
    plugin,
    ...
  }: let
    name = plugin.name "slaputtt";
    cfg = config.neo.services.${name};
    site = withSystem pkgs.stdenv.hostPlatform.system ({config, ...}: config.packages.web);
    # Other sites of the shared host nginx on the same port would answer for this one.
    clashes = lib.attrNames (lib.filterAttrs (
        n: v: n != name && lib.any (l: (l.port or null) == cfg.port) (v.listen or [])
      )
      config.services.nginx.virtualHosts);
  in {
    config = lib.mkIf cfg.enabled (lib.mkMerge [
      (lib.neo.mkDockerToLocalhostForward cfg.port)
      {
        warnings = lib.optional (clashes != []) "${name}: port ${toString cfg.port} is also used by ${lib.concatStringsSep ", " clashes}; give each site its own port.";

        # nginx itself is switched on by nginx.nix (one per machine).
        services.nginx = {
          virtualHosts.${name} = {
            listen = [
              {
                addr = "127.0.0.1";
                port = cfg.port;
              }
            ];
            root = site;
            # Three real pages, no client routes: a missing file is a 404. With
            # the old index.html fallback a missing AI worker or opponent file
            # came back as 200, the AI never moved and no log showed it.
            # The store files have mtime 1970, so make browsers revalidate (304)
            # instead of caching them heuristically; a new build reaches
            # visitors at once.
            locations."/" = {
              tryFiles = "$uri $uri/ =404";
              extraConfig = ''
                add_header Cache-Control "no-cache";
              '';
            };
          };
        };
      }
    ]);
  };
}
