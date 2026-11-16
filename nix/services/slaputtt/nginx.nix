# The host nginx itself is one per machine, shared by every copy of this plugin
# and by other static-site plugins: the per-copy vhost lives in default.nix.
# neo-plugin-instances leaves this module out, since nginx's unit and user keep
# their names in every copy.
{
  lib,
  options,
  ...
}: {
  neoPlugin =
    {
      modules.slaputtt-nginx = {
        config,
        lib,
        plugin,
        ...
      }: {
        config.services.nginx.enable = lib.mkIf config.neo.services.${plugin.name "slaputtt"}.enabled true;
      };
    }
    // lib.optionalAttrs (options.neoPlugin ? checkExclude) {
      checkExclude = ["slaputtt-nginx"];
    };
}
