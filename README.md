# Project 2: Cron Job Automation

Part of the *Simple Linux Projects for Cloud Engineers* series. Schedules the [Project 1](https://github.com/Elixirman/linux-cloud-project1-Automated-backup-) backup script to run unattended every night via `cron` — and, more importantly, fixes the assumptions in that script that only held true when a human was present to run it by hand.

🔗 **[View Live Write-Up](https://elixirman.github.io/linux-cloud-project2-Cron-Automation-/)** — full walkthrough, hosted from `index.html` via GitHub Pages (Settings → Pages → Deploy from branch `main` → `/ (root)`).

## What this project does

- Runs `backup.sh` automatically every day at 02:00 via a personal crontab entry
- Redirects the script's output to a log file, since cron gives no terminal to print to
- Makes the script self-locating (`SCRIPT_DIR` derived from `$0`) instead of relying on `$HOME`, so it behaves identically whether run interactively or by cron
- Was verified with a real, near-term unattended test run before being trusted to the actual 2 AM schedule

## Repository contents

| File / folder | Purpose |
|---|---|
| [`backup.sh`](backup.sh) | The backup script, updated to be self-locating and safe to run from any context |
| [`backups/`](backups) | Where archives and `backup.log` are written (both generated and git-ignored — only the folder structure is tracked) |
| [`index.html`](index.html) | The full write-up: the cron environment problem, the script fix, crontab syntax, the testing method, a `.gitignore` precedence issue encountered along the way, and evidence of an unattended run |
| [`.gitignore`](.gitignore) | Excludes generated archives and logs; deliberately written as an explicit list rather than a broad wildcard (see `index.html` §8 for why) |
| [`LICENSE`](LICENSE) | MIT |
| [`Schema.svg`](Schema.svg) | Architecture diagram of the cron → script → archive/log flow |

## Architecture

![Cron automation architecture](schema_.png)

Cron wakes every minute, matches the `0 2 * * *` schedule, and invokes `backup.sh` directly — bypassing the interactive shell environment (dashed box) that an earlier version of the script mistakenly relied on. Output branches into `backup.log` via explicit redirection, since cron gives the script no terminal to print to.

## The crontab entry

```
0 2 * * * /home/linux-guy/linux-project2/backup.sh >> /home/linux-guy/linux-project2/backups/backup.log 2>&1
```

Runs `backup.sh` daily at 02:00, appending both standard output and standard error to `backups/backup.log`.

## Running it manually

```bash
chmod +x backup.sh
./backup.sh
```

Check the log after any run — manual or scheduled:

```bash
cat backups/backup.log
```

## Approach

- **Unattended-first design.** The script assumes no interactive shell, no inherited `$HOME`, and no guaranteed working directory — everything it needs is derived from its own file location.
- **Verified, not assumed.** The nightly schedule was proven with a real near-term test run (see `index.html` §7 and §10) before being left to run unattended for real.
- **Failures documented, not hidden.** `index.html` includes the actual issues hit while building this — a `.gitignore` precedence trap, a shell history-expansion gotcha, a missed executable bit — because those are the genuinely useful parts of a production write-up.

For the full explanation of every design decision and the reasoning behind each one, see [`index.html`](index.html).

## License

MIT — see [LICENSE](LICENSE).
