# Redmine Container Image

## Description

This repository contains Containerfiles and associated scripts for container images that run [Redmine](https://www.redmine.org/).

These images are **not** based on the original Redmine Docker Image. They are built from scratch using Ruby on Debian Bookworm base images (`ruby:3.3-bookworm` for 6.0, `ruby:3.4-bookworm` for 6.1).

### Supported Versions

| Version | Redmine | Base Image | Status |
|---------|---------|------------|--------|
| 6.0 | 6.0.10 | ruby:3.3-bookworm | Active |
| 6.1 | 6.1.3 | ruby:3.4-bookworm | Active |

**Redmine 5.x support has been dropped.** The last 5.1 image is deprecated and no longer maintained.

### Design Goals

- **No root user** — everything runs under the `redmine` user (UID 34342)
- **Read-only root filesystem** — compatible with Kubernetes security best practices
- **Reproducible restarts** — no updates during container start (except database migrations)
- **Easy Sidekiq and Redis integration**

---

## Included Plugins

Both 6.0 and 6.1 images include the same set of plugins, but with different versions to ensure Redmine compatibility.

### Plugin List

| Plugin | 6.0 Version | 6.1 Version |
|--------|-------------|-------------|
| [redmine_issue_dynamic_edit](https://github.com/Ilogeek/redmine_issue_dynamic_edit) | `56ad17d0` | `56ad17d0` |
| [redmine_dashboard](https://github.com/jgraichen/redmine_dashboard) | `v2.16.0` | `v2.16.0` |
| [redmine_wiki_extensions](https://github.com/haru/redmine_wiki_extensions) | `895e5707` | `1.2.0` |
| [additionals](https://github.com/alphanodes/additionals) | `3.4.0` | `4.5.0` |
| [additional_tags](https://github.com/alphanodes/additional_tags) | `3.4.0` | `4.5.0` |
| [redmine_messenger](https://github.com/alphanodes/redmine_messenger) | `1.0.8` | `1.0.14` |
| [redmine_drawio](https://github.com/mikitex70/redmine_drawio) | `v1.5.5` | `v1.5.5` |
| [redmica_ui_extension](https://github.com/redmica/redmica_ui_extension) | `v0.3.10` | `v0.6.0` |
| [redmine_view_customize](https://github.com/onozaty/redmine-view-customize) | `v3.6.0` | `v3.6.0` |
| [redmine_privacy_terms](https://github.com/alphanodes/redmine_privacy_terms) | `1.0.2` | `1.0.4` |
| [redmine_ref_issues](https://github.com/alphanodes/redmine_ref_issues) | `0.0.9` | `1.0.3` |
| [redmine_wiki_pathbase_acl](https://github.com/9506hqwy/redmine_wiki_pathbase_acl) | `fbebf71a` | `fbebf71a` |
| [redmine_startpage](https://github.com/Intera/redmine_startpage) | `dd539411` | `dd539411` |
| [redmine_spent_time](https://github.com/eyp/redmine_spent_time) | `cdd3d078` | `cdd3d078` |
| [redmine_percent_done](https://github.com/jkraemer/redmine_percent_done) | `v1.1.0` | `e2ed5e6a` |
| [redmine_documents_short](https://github.com/smoreau/redmine_documents_short) | `860912ae` | `860912ae` |
| [redmine_vividtone_my_page_blocks](https://github.com/redmica/redmine_vividtone_my_page_blocks) | `v1.4.1` | `v1.4.1` |
| [kanban](https://github.com/happy-se-life/kanban) | `HEAD` | `1b1ac1ea` |
| [redmine_msteams_notification](https://github.com/9506hqwy/redmine_msteams_notification) | `0.7.0` | `0.7.0` |
| [redmine_budget_tn](https://github.com/aouaiti/redmine_Budget_tn) | `0212de83` | `0212de83` |
| [redmine_periodic_task](https://github.com/jperelli/Redmine-Periodic-Task) | | `v6.2.0` |

### Theme

| Theme | 6.0 Version | 6.1 Version |
|-------|-------------|-------------|
| [redmine_theme_farend_bleuclair](https://github.com/farend/redmine_theme_farend_bleuclair) | `HEAD` | `v2.0.3` |

### Version Notes

- **additionals / additional_tags**: Must share the same version. 6.0 uses `3.4.0` (compatible with Redmine ≥5.0); 6.1 uses `4.5.0` (requires Redmine ≥6.1).
- **redmine_messenger / redmine_privacy_terms / redmine_ref_issues**: Alphanodes plugins — versions must be compatible with the installed `additionals` version.
- **redmine_dashboard**: `v2.16.0` is the latest stable. The `v3` on master is pre-alpha and not used.
- **redmine_wiki_extensions**: Tag `0.3.1` predates Redmine 6.0. Both images use commit/tag `1.2.0` which requires Redmine 6.0+.
- **redmine_preview_pdf**: Commented out in both images — last updated 2021, likely incompatible with Redmine 6.x.

---

## Usage

This image uses its own entrypoint script with custom environment variables — **not** the same as the official Redmine Docker Image.

### Environment Variables

#### Database Configuration (required)

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_ADAPTER` | Database type: `sqlite3`, `mysql`, or `postgres` | *(required)* |

**SQLite:**

| Variable | Description | Default |
|----------|-------------|---------|
| `SQLITE_FILE` | Path to the SQLite database file | *(required when using sqlite3)* |

> **Note:** SQLite is not supported in the 6.1 image — the additionals plugin does not support SQLite. Use the 6.0 image if you need SQLite.

**MySQL:**

| Variable | Description | Default |
|----------|-------------|---------|
| `MYSQL_HOST` | MySQL server hostname or IP | *(required)* |
| `MYSQL_PORT` | MySQL port | `3306` |
| `MYSQL_USER` | MySQL username | `redmine` |
| `MYSQL_PASSWORD` | MySQL password | *(required)* |
| `MYSQL_DB` | Database name | `redmine` |

**PostgreSQL:**

| Variable | Description | Default |
|----------|-------------|---------|
| `PSQL_HOST` | PostgreSQL server hostname or IP | *(required)* |
| `PSQL_PORT` | PostgreSQL port | `3306` |
| `PSQL_USER` | PostgreSQL username | `redmine` |
| `PSQL_PASSWORD` | PostgreSQL password | *(required)* |
| `PSQL_DB` | Database name | `redmine` |

**Note:** SQLite is not supported in the 6.1 image because the additionals plugin does not support SQLite. Use the 6.0 image if you need SQLite.

#### Optional

| Variable | Description | Default |
|----------|-------------|---------|
| `REDMINE_LANG` | Default language for initial data import | `EN` |
| `SIDEKIQ` | Set to `true` to run Sidekiq worker instead of the web server | *(run web server)* |
| `USE_SIDEKIQ` | Set to enable Sidekiq as the ActiveJob queue adapter | *(disabled)* |
| `REDIS_URL` | Redis connection URL (required when `SIDEKIQ=true`) | *(required when using Sidekiq)* |

### Persistent Storage

Mount a volume at `/home/redmine/redmine/files` to persist data across container restarts. The `files/.initialized` marker determines whether the container runs first-time initialization (database setup, default data, plugin migrations).

### Building

```bash
# Build Redmine 6.1
docker build -t redmine:6.1 ./6.1/

# Build Redmine 6.0
docker build -t redmine:6.0 ./6.0/
```

---

## Security

These images address security limitations of the original Redmine Docker Image:

- **Read-only root filesystem** — meets Kubernetes security best practices
- **No runtime updates** — container image is immutable; no surprise breakages from dependency updates on restart
- **Non-root user** — all processes run as `redmine` (UID 34342)

---

## Supported Architectures

- amd64
- arm64

## Updates

Images are updated regularly while my private Kubernetes cluster is available. I do not promise SLAs — do **not** rely on this image for mission-critical business operations without testing.

## Prebuilt Images

- https://hub.docker.com/repository/docker/byterazor/redmine/general

## Git Repository

- https://gitea.federationhq.de/Container/redmine

## Authors

- **Dominik Meyer** — Container image, plugin integration, and themes

## License

This project is licensed under the GPLv2 License — see the [LICENSE](LICENSE) file for details.