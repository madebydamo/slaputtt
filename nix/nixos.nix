# Every neoPlugin.modules.* under nix/ is a NixOS module with an extra `plugin`
# argument. A homeserver can add this plugin twice under different prefixes, so
# every name a module puts into the system goes through `plugin.name "<service>"`.
{...}: {
  systems = ["x86_64-linux" "aarch64-linux"];
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
