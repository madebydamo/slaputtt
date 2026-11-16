# Dashboard and alert rules (Monitoring, Grafana's Apps folder). The site has no
# server code: everything comes from SWAG's access log, i.e. the files browsers
# load and the /_e/ beacon events the pages send
# (uttt_website/web/components/Telemetry.dart):
#   /_e/game/start/<level>/<ai>/<depth>   a game starts
#   /_e/game/end/<won|lost|draw>/<level>/<ai>   result from the player's side
#   /_e/era/<ai>/<ok|error>               the trained opponents were loaded
#   /_e/evo/<ai>/<new|train|mutate|upload|download|compare>   research pages
#   /_e/error/<js|worker|era>             script errors (max 5 a page view)
# level: easy|medium|hard (play page), best (last generation's best, research
# pages), picked (chosen in the list); ai: ga (genetic algorithm) | pso
# (particle swarm). No metrics endpoint, so no `metrics` and no `collecting`.
{...}: {
  neoPlugin.modules.slaputtt-monitoring = {
    config,
    lib,
    plugin,
    ...
  }: let
    name = plugin.name "slaputtt";
    cfg = config.neo.services.${name};
    label = "Ultimate Tic Tac Toe${plugin.label}";
    swag = ''{job="swag", service="${name}", host=~"$host"}'';
    countExpr = re: ''sum(count_over_time(${swag} | path=~`${re}` [$__range])) or vector(0)'';
    count = re: lib.neo.grafana.lq (countExpr re) // {queryType = "instant";};
    # Files without which the game or the computer opponent does not work.
    gameFiles = ''/(beginner|main|particle)\.dart\.js|/worker/algorithm/.*|/[0-9]+_[0-9A-Za-z_]+\.json|/vendor/.*'';
    red = lib.neo.grafana.thresholdsGreenRed [
      {
        color = "red";
        value = 1;
      }
    ];
  in {
    config = lib.mkIf cfg.enabled {
      neo.monitoring.apps.${name} = {
        dashboards.overview = {
          title = label;
          description = "Games against the self-taught computer opponents: how many, at which level, who wins, and whether the opponents load.";
          time = "now-7d";
          panels = with lib.neo.grafana;
            [
              (row "Games" null)
              (stat {
                title = "Games started";
                w = 4;
                h = 4;
                datasource = loki;
                targets = [(count "/_e/game/start/.*")];
                decimals = 0;
              })
              (stat {
                title = "Games finished";
                w = 4;
                h = 4;
                datasource = loki;
                targets = [(count "/_e/game/end/.*")];
                decimals = 0;
              })
              (stat {
                title = "Players won";
                w = 4;
                h = 4;
                description = "Share of finished games the human player won.";
                datasource = loki;
                unit = "percentunit";
                targets = [
                  (lq "(${countExpr "/_e/game/end/won/.*"}) / clamp_min(${countExpr "/_e/game/end/.*"}, 1)"
                    // {queryType = "instant";})
                ];
              })
              (stat {
                title = "Opponents loaded";
                w = 4;
                h = 4;
                description = "Page views whose trained opponents loaded, so a game could start.";
                datasource = loki;
                targets = [(count "/_e/era/[a-z]+/ok")];
                decimals = 0;
              })
              (stat {
                title = "Game files missing";
                w = 4;
                h = 4;
                description = "Requests for a page script, the computer opponent or the opponents file that got a 404. Anything above 0 means the game is broken.";
                datasource = loki;
                targets = [
                  (lq ''sum(count_over_time(${swag} | status="404" | path=~`${gameFiles}` [$__range])) or vector(0)''
                    // {queryType = "instant";})
                ];
                decimals = 0;
                thresholds = red;
              })
              (stat {
                title = "Script errors";
                w = 4;
                h = 4;
                description = "Errors in visitors' browsers: scripts, the computer opponent, loading the opponents.";
                datasource = loki;
                targets = [(count "/_e/error/.*")];
                decimals = 0;
                thresholds = red;
              })
              (bars {
                title = "Games by level";
                w = 12;
                h = 8;
                datasource = loki;
                targets = [(lqLegend ''sum by (level) (count_over_time(${swag} | path=~`/_e/game/start/.*` | regexp `"uri":"/_e/game/start/(?P<level>[a-z]+)/` [$__interval]))'' "{{level}}")];
              })
              (bargauge {
                title = "Results by level";
                w = 12;
                h = 8;
                description = "Finished games by level and result, from the player's side: is Hard actually hard?";
                datasource = loki;
                targets = [(lqLegend ''sum by (level, result) (count_over_time(${swag} | path=~`/_e/game/end/.*` | regexp `"uri":"/_e/game/end/(?P<result>[a-z]+)/(?P<level>[a-z]+)/` [$__range]))'' "{{level}} {{result}}")];
              })
              (bargauge {
                title = "Opponent type";
                w = 8;
                h = 8;
                description = "Games by how the opponent was trained: ga = genetic algorithm, pso = particle swarm.";
                datasource = loki;
                targets = [(lqLegend ''sum by (ai) (count_over_time(${swag} | path=~`/_e/game/start/.*` | regexp `"uri":"/_e/game/start/[a-z]+/(?P<ai>[a-z]+)/` [$__range]))'' "{{ai}}")];
              })
              (bargauge {
                title = "Search depth";
                w = 8;
                h = 8;
                description = "How many moves ahead the opponent looked; the research pages let visitors change it.";
                datasource = loki;
                targets = [(lqLegend ''sum by (depth) (count_over_time(${swag} | path=~`/_e/game/start/.*` | regexp `"uri":"/_e/game/start/[a-z]+/[a-z]+/(?P<depth>[0-9]+)"` [$__range]))'' "depth {{depth}}")];
              })
              (bargauge {
                title = "Opponent files by type";
                w = 8;
                h = 8;
                description = "Opponent files loaded per type and result.";
                datasource = loki;
                targets = [(lqLegend ''sum by (ai, result) (count_over_time(${swag} | path=~`/_e/era/.*` | regexp `"uri":"/_e/era/(?P<ai>[a-z]+)/(?P<result>[a-z]+)"` [$__range]))'' "{{ai}} {{result}}")];
              })
              (row "Research pages" null)
              (bargauge {
                title = "Pages";
                w = 12;
                h = 8;
                description = "Play page against the pages that show and continue the training.";
                datasource = loki;
                targets = [(lqLegend ''sum by (path) (count_over_time(${swag} | path=~`/|/(index|advanced|particle)\.html` [$__range]))'' "{{path}}")];
              })
              (bars {
                title = "Training actions";
                w = 12;
                h = 8;
                datasource = loki;
                targets = [(lqLegend ''sum by (ai, action) (count_over_time(${swag} | path=~`/_e/evo/.*` | regexp `"uri":"/_e/evo/(?P<ai>[a-z]+)/(?P<action>[a-z]+)"` [$__interval]))'' "{{ai}} {{action}}")];
              })
            ]
            ++ lib.neo.grafana.app.beacon {service = name;}
            ++ lib.neo.grafana.app.web {service = name;}
            # The host nginx is shared with other static sites, so its error
            # lines may belong to them; it logs plain text, not JSON.
            ++ lib.neo.grafana.app.errors {
              service = name;
              containers = [];
              units = ["nginx"];
              filter = "|~ `(?i)\\[(error|crit|alert|emerg)\\]`";
              metrics = false;
            };
        };

        # No containers and no metrics, and the host nginx is shared with other
        # sites (its errors would be blamed on this one), so appAlerts adds no
        # rule here; the rules below read the beacon and SWAG's log.
        alerts =
          lib.neo.monitoring.appAlerts {
            service = name;
            inherit label;
          }
          // {
            files-missing = {
              title = "${label}: game files missing";
              datasource = "loki";
              expr = ''sum by (host) (count_over_time({job="swag", service="${name}"} | status="404" | path=~`${gameFiles}` [15m]))'';
              above = 0;
              for = "0s";
              summary = "${label} on {{ $labels.host }}: {{ printf \"%.0f\" $values.B.Value }} requests for a page script, the computer opponent or its opponents file were not found in 15 minutes, so the game does not work. Rebuild and activate the plugin.";
            };
            script-errors = {
              title = "${label}: errors in visitors' browsers";
              datasource = "loki";
              expr = ''sum by (host) (count_over_time({job="swag", service="${name}"} | path=~`/_e/error/.*` [15m]))'';
              above = 10;
              for = "0s";
              summary = "${label} on {{ $labels.host }}: visitors' browsers reported {{ printf \"%.0f\" $values.B.Value }} script, computer-opponent or loading errors in 15 minutes.";
            };
          };
      };
    };
  };
}
