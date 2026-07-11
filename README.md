# slaputtt

Self Learning Alpha-Beta Pruning Ultimate Tic Tac Toe.

Project is based on Dart. Compatible plugin for [neo](https://github.com/madebydamo/neo).

## Quick Start (with Nix)

This project uses Nix flakes for reproducible setup.

```bash
nix develop          # enter dev shell (Dart + just + tools)
just                 # list available commands
just launch          # start local dev server at http://localhost:8080
```

## Available Commands

| Command       | Description                         |
| ------------- | ----------------------------------- |
| `just launch` | Launch web dev server (live reload) |
| `just test`   | Run tests in `uttt_package`         |
| `just format` | Format Nix files with alejandra     |
| `just check`  | Run `nix flake check`               |

## Manual setup (without Nix)

Install Dart first. Then:

```bash
cd uttt_website
dart pub get
dart pub global activate webdev
webdev serve
```

Maybe run `webdev build` in `uttt_package` if some dependencies are missing.

## Investigation

Core logic lives in [uttt_package](./uttt_package). Web UI is in [uttt_website](./uttt_website).

## Neo plugin

Add this flake under **Settings → neo-service → plugins**, then enable the **slaputtt** service:

```text
github:madebydamo/slaputtt
```

Or locally:

```text
path:/home/you/projects/slaputtt
```
