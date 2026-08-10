# Slaputtt reverse proxy configuration for SWAG.
{...}: {
  flake.modules.nixos.slaputtt-swag = {
    config,
    lib,
    ...
  }: let
    cfg = config.neo.services.slaputtt;
  in {
    config.neo.services.slaputtt.proxyConf = lib.mkDefault ''
      server {
        include /config/nginx/listen-https.conf;
        http2 on;
        server_name ${cfg.subdomain}.*;
        include /config/nginx/ssl.conf;
        include /config/nginx/geo-access.conf;
        client_max_body_size 0;

        location / {
          include /config/nginx/proxy.conf;
          proxy_pass http://host.docker.internal:${toString cfg.port}/;

          ${lib.neo.authBlock config cfg}
        }
        ${lib.neo.authLocations config cfg}
      }
    '';
  };
}
