# Hermes skill for Ultimate Tic Tac Toe (published as neo-<name>).
{...}: {
  neoPlugin.modules.slaputtt-skills = {
    config,
    lib,
    plugin,
    ...
  }: let
    name = plugin.name "slaputtt";
    cfg = config.neo.services.${name};
    publicUrl = lib.defaultTo "https://<subdomain>.<domain>" (lib.neo.publicUrl config cfg);
    local = "http://127.0.0.1:${toString cfg.port}";
  in {
    config.neo.services.${name}.skill.conf = lib.neo.mkServiceSkill {
      service = name;
      inherit config;
      description = "Ultimate Tic Tac Toe web game with evolved AI opponents (static site, runs in the browser)";
      tags = ["neo" "slaputtt" "game"];
      title = "Neo · Ultimate Tic Tac Toe${plugin.label}";
      body = ''
        ## When to Use
        Questions whether the Ultimate Tic Tac Toe game is up, why the computer does not move or the level buttons are missing, or how often it is played.

        ## Architecture notes
        - Static site built by the plugin (Dart compiled to JavaScript); no server code, no container, no data
        - Served by the host nginx (`nginx.service`, shared with other static sites) on 127.0.0.1:${toString cfg.port}; SWAG reaches it through host.docker.internal
        - Public URL: ${publicUrl}/ (no login by default). Pages: `/` (play, levels Easy/Medium/Hard), `/advanced.html` (genetic algorithm), `/particle.html` (particle swarm)
        - The computer opponent runs in a Web Worker loaded from `/worker/algorithm/AlgorithmBackgroundWorker.dart.js`; opponents come from `/17_3G70.json` (play and advanced) and `/16_2G20P.json` (particle)
        - Third-party scripts, styles and the icon font are served from `/vendor/` on this server
        - The page reports events to `/_e/…` (answered 204 by the host nginx), counted from SWAG's access log on the Ultimate Tic Tac Toe dashboard (Grafana, Apps folder)

        ## Procedures
        1. `systemctl is-active nginx`
        2. `curl -sS -o /dev/null -w '%{http_code}\n' ${local}/` returns 200
        3. The AI files answer 200: `${local}/17_3G70.json`, `${local}/16_2G20P.json`, `${local}/worker/algorithm/AlgorithmBackgroundWorker.dart.js`, `${local}/beginner.dart.js`
        4. Through SWAG: `docker exec swag curl -sS -o /dev/null -w '%{http_code}\n' http://host.docker.internal:${toString cfg.port}/`
        5. Errors: `journalctl -u nginx -b | grep -iE 'error|emerg'`

        ## Pitfalls
        - Missing files answer 404 on purpose (no fallback to index.html): a 404 on a `.js` or opponent `.json` file means the build is broken, so rebuild and activate, do not add a fallback
        - The host nginx serves other sites too: never stop or restart it for this site alone without saying so
        - A second copy of this plugin needs its own Local port

        ## Verification
        - `nginx.service` active; `/`, the opponent files and the worker script answer 200 on ${local}
        - ${publicUrl}/ answers 200
      '';
    };
  };
}
