# Docker machines

Each OrbStack Linux machine runs its own official Docker engine. Projects on different machines can publish the same port, including 8080.

| Repository root | Machine | Docker endpoint |
|---|---|---|
| `~/Code/gq` | `gq` | `ssh://gq@orb` |
| `~/Code/jeangnc` | `me` | `ssh://me@orb` |
| `~/Code/skip-visa-queue` | `svq` | `ssh://svq@orb` |

## Daily use

Open a new terminal or run `source ~/.zshenv` in an existing one. Zsh selects `DOCKER_HOST` at startup and when changing directories. Git worktrees follow their main checkout, including worktrees outside these roots. Existing `make`, `just`, and `docker compose` commands use that engine.

```sh
docker info --format '{{.Name}}'
docker compose ps
```

Named contexts work from any directory and override automatic routing:

```sh
docker --context gq ps
docker --context me ps
docker --context svq ps
docker --context orbstack ps
```

An explicit `DOCKER_HOST` is preserved. Use a named `--context` flag for a one-command override; `DOCKER_CONTEXT=...` inline can lose precedence to an inherited `DOCKER_HOST` with the installed Docker CLI. To pin the same host that routing already selected, first `unset DOTFILES_DOCKER_HOST_AUTO`. To resume routing, `unset DOCKER_HOST DOCKER_CONTEXT DOTFILES_DOCKER_HOST_AUTO` and change directories.

## Access from this Mac

| Project | Address |
|---|---|
| Great Question | `http://localhost:3000` (existing login and MCP origin), `http://gq.orb.local:3000` |
| GQ webpack | `http://gq.orb.local:8080` |
| Budget web | `http://me.orb.local:5173` |
| Budget API | `http://me.orb.local:8080` |
| SVQ control panel | `http://localhost:3001` (existing OAuth callback), `http://svq.orb.local:3001` |
| SVQ bot API, when started | `http://svq.orb.local:8082` |

Machine hostnames select an engine even when ports overlap. Keep the existing localhost origin for GQ authentication/MCP and SVQ OAuth because their saved tokens or provider callbacks use it. Localhost forwarding is suitable only for ports used by one running machine.

Budget's local mobile configuration uses `http://me.orb.local:8080`. The app now honors an explicit `EXPO_PUBLIC_API_URL` before its Metro-host fallback. These `.orb.local` names are for this Mac; access from a physical phone needs a reachable LAN address.

## Local configuration and data

Git-ignored Compose overrides hold machine-specific settings: GQ's webpack URL; Budget's Vite hostname and API CORS origin; SVQ's guest host gateway and persistent Ruby bundle. Keep those overrides when recreating containers. SVQ's bot worker and GQ Next were stopped before migration and remain stopped.

The original containers, images, and volumes remain in the `orbstack` context. Unreferenced historical volumes also remain there. Do not start both copies of a project: writes can diverge and localhost forwarding can select the wrong copy.

The final GQ source database is read-only. Its pre-cutover target database is retained under a `gq_before_cutover_...` name inside the new GQ PostgreSQL instance. To roll back, stop the new project, preserve any newer data, then start its original containers explicitly through `--context orbstack`. Reset GQ's source read-only setting from the `postgres` maintenance database before resuming writes:

```sh
docker --context orbstack exec great_question-db-1 psql -U postgres -d postgres -c 'ALTER DATABASE gq_development RESET default_transaction_read_only'
```

Official Docker still has the reproduced failed-port-bind network-state defect within one engine. Separate machines isolate cross-project groups; projects sharing one machine still share its host ports. No custom Docker daemon is installed.

## Routing regression checks

Run on this Mac with its project checkouts present:

```sh
python3 tests/test_docker_host.py
zsh -n zsh/docker-host.zsh
```
