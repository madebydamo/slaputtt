# Reverse proxy for SWAG: https://<subdomain>.<domain> → host nginx on loopback.
# The browser event beacon /_e/ is answered by the host nginx (default.nix), so
# it goes through `location /` like every other path.
{...}: {
  neoPlugin.modules.slaputtt-swag = {
    config,
    lib,
    plugin,
    ...
  }: let
    name = plugin.name "slaputtt";
    cfg = config.neo.services.${name};
  in {
    config.neo.services.${name}.proxyConf = lib.mkDefault (lib.neo.mkSubdomainProxyConf {
      inherit config cfg;
      proxyPass = "http://host.docker.internal:${toString cfg.port}/";
    });
  };
}
