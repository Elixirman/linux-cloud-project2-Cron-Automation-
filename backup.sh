#!/bin/bash
SOURCE_DIR="/var/www/html"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "Starting backup of '$SOURCE_DIR'..."
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

if [ $? -eq 0 ]; then
    echo "SUCCESS: Backup created at '$BACKUP_FILE'"
    exit 0
else
    echo "ERROR: Backup failed."
    exit 1
fi
