#!/bin/bash
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
CONFIG_FILE="$SCRIPT_DIR/config.txt"
LOG_FILE="$SCRIPT_DIR/backup.log"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found!" | tee -a "$LOG_FILE"
    exit 1
fi
source "$CONFIG_FILE"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$DESTINATION/recover"
ZIP_FILE="$DESTINATION/.recover.zip"
mkdir -p "$BACKUP_DIR" | tee -a "$LOG_FILE"
if [ -f "$ZIP_FILE" ]; then
    rm "$ZIP_FILE"
fi
IFS=',' read -r -a FILE_ARRAY <<< "$FILES"
for item in "${FILE_ARRAY[@]}"; do
    if [[ -e "$item" ]]; then
        cp -r "$item" "$BACKUP_DIR" 2>>"$LOG_FILE"
    else
        echo "Warning: $item not found" | tee -a "$LOG_FILE"
    fi
done
zip -r "$ZIP_FILE" "$BACKUP_DIR" 2>> "$LOG_FILE"
rm -rf "$BACKUP_DIR"
echo "Backup completed successfully at $TIMESTAMP" | tee -a "$LOG_FILE"
