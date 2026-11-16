# Ultimate Tic Tac Toe options.
# Every file under nix/ is auto-imported (import-tree). Do not `imports` siblings.
{...}: {
  neoPlugin.modules.slaputtt-option = {
    config,
    lib,
    plugin,
    ...
  }:
    with lib;
    with {inherit (lib.neo) mkOption mkEnableOption;}; let
      name = plugin.name "slaputtt";
    in {
      options.neo.services.${name} = mkOption {
        type = types.submodule {
          options =
            {
              enabled = mkEnableOption "Ultimate Tic Tac Toe against a self-taught computer opponent${plugin.label}" {rank = 0;};
              # The host nginx listens on 127.0.0.1:<port>; SWAG reaches it through
              # host.docker.internal. Two sites on one port collide (default.nix warns).
              port = mkOption {
                type = types.port;
                default = 8124;
                rank = 10;
                description = "Port the site uses inside this server, never reachable from outside. Change it only when another app uses the same one; a second copy of this app needs its own.";
                ui = lib.neo.ui.mkUi {
                  group = lib.neo.ui.groups.advanced;
                  label = "Local port";
                };
              };
            }
            // lib.neo.mkReverseProxyOptions {
              subdomain = name;
              # A public game: nothing to protect, no accounts.
              auth.enabled = false;
            }
            # Served by the shared host nginx (default.nix); Neo keeps nginx out of
            # the per-service target, so stopping this site does not stop others.
            // lib.neo.mkSystemdUnits ["nginx"]
            // lib.neo.mkServiceMeta {
              icon = ../../../uttt_website/web/tictactoe.png;
              tagline = "Play Ultimate Tic Tac Toe against a self-taught AI";
              description = ''
                A tougher tic-tac-toe where every square holds its own small board. Play against computer opponents at three levels, or see how they learned by playing against each other and train new ones.
                It runs in the visitor's browser and stores nothing.
              '';
              notes = ''
                The opponents were trained with a genetic algorithm and with particle swarm optimisation; the Advanced and PSO pages show and continue that training in the visitor's browser, which can keep the computer busy for minutes. Works best in Chrome or Firefox.
                Open to everyone by default (no login). The site is served by the server's own web server, shared with other static sites; all scripts and fonts come from this server, none from other sites.
              '';
              replaces = [];
              privacy = [];
              license = {
                spdx = "MIT";
                url = "https://github.com/madebydamo/slaputtt/blob/master/LICENSE";
              };
              githubUrl = "https://github.com/madebydamo/slaputtt";
            }
            // lib.neo.mkSkillOptions {};
        };
        default = {};
        description = "Ultimate Tic Tac Toe web game";
      };
    };
}
