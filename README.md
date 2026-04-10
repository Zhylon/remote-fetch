# Zhylon Remote Fetch

Simple bash tool to fetch files/directories from remote servers as tar.gz archives.
Works on macOS and Linux.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/zhylon/remote-fetch/main/install.sh | bash
```

Update later with the same command, or:

```bash
remote-fetch --update
```

## Configure

```bash
remote-fetch config add prod
remote-fetch config edit
```

`~/.config/remote-fetch/servers.conf`:

```ini
[prod]
host=deploy@prod.example.com
key=~/.ssh/id_ed25519
port=22

[staging]
host=user@staging.example.com
key=~/.ssh/staging_key
```

List servers: `remote-fetch config list`

## Usage

**Default workflow** — pack on remote, download, extract locally, clean up both sides:

```bash
remote-fetch prod /var/www/app/storage/logs
```

**Into a specific output directory:**

```bash
remote-fetch prod /var/www/app/storage -o ~/backups
```

**Keep things around** (any combination):

```bash
remote-fetch prod /var/www/app/storage --keep-remote --keep-local --no-extract
```

| Flag | Effect |
|---|---|
| `--keep-remote` | don't delete the tar.gz on the remote server |
| `--keep-local` | don't delete the tar.gz after extracting |
| `--no-extract` | don't extract locally (implies keep-local) |
| `-o <dir>` | output directory (default: current dir) |

**Direct copy** — single file or dir, no tar wrapping (uses rsync):

```bash
remote-fetch copy prod /var/www/app/.env
remote-fetch copy prod /var/www/app/.env ~/secrets
```

## Commands

```
remote-fetch <server> <remote-path> [flags]   # default: tar workflow
remote-fetch copy <server> <path> [out-dir]   # direct rsync
remote-fetch config list|edit|add <n>|path
remote-fetch --update
remote-fetch --version
```

## Requirements

`ssh`, `rsync`, `tar`, `curl` — all preinstalled on macOS and standard Ubuntu.

## How it works

Default fetch runs (in order):
1. `ssh remote "tar czf /tmp/xxx.tar.gz <path>"`
2. `rsync` pulls the archive with `--partial` (resumable)
3. `tar xzf` locally
4. `rm` both archives

Each step can be disabled via flags.
