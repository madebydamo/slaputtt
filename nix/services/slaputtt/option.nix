# Slaputtt service options.
{...}: {
  flake.modules.nixos.slaputtt-option = {
    config,
    lib,
    ...
  }:
    with lib;
    with {inherit (lib.neo) mkOption mkEnableOption;}; {
      options.neo.services.slaputtt = mkOption {
        type = types.submodule {
          options =
            {
              enabled = mkEnableOption "Slaputtt service" {rank = 0;};
              port = mkOption {
                type = types.port;
                default = 8124;
                description = "Port for the slaputtt nginx server";
                rank = 10;
              };
            }
            // neo.mkReverseProxyOptions {
              subdomain = "slaputtt";
              auth.enabled = false;
            }
            // lib.neo.mkServiceMeta {
              icon = "https://upload.wikimedia.org/wikipedia/commons/3/32/Tic_tac_toe.svg";
              description = ''
                Self Learning Alpha-Beta Pruning Ultimate Tic Tac Toe.
                Play against evolved AI opponents with alpha-beta search.
              '';
              projectUrl = "https://github.com/madebydamo/slaputtt";
              githubUrl = "https://github.com/madebydamo/slaputtt";
            };
        };
        default = {};
        description = "Ultimate Tic Tac Toe web service configuration";
      };
    };
}
