#!/bin/bash
CONFIG_FILE="$(pwd)/config.txt"
echo -n "Enter the list of files and folders to back up (comma-separated):"
read files
echo -n "Enter the destination folder for backup:"
read destination
echo -n "Select backup frequency (daily/weekly/monthly/yearly):"
read frequency
if [[ -z "$files" || -z "$destination" || -z "$frequency" ]]; then
    echo "Error: All fields are required."
    exit 1
fi
echo "FILES=\"$files\"" > "$CONFIG_FILE"
echo "DESTINATION=\"$destination\"" >> "$CONFIG_FILE"
echo "FREQUENCY=\"$frequency\"" >> "$CONFIG_FILE"
echo "Configuration saved to $CONFIG_FILE"
CRON_SCHEDULE=""
case "$frequency" in
    daily)   CRON_SCHEDULE="0 0 * * *" ;;
    weekly)  CRON_SCHEDULE="0 0 * * 0" ;;
    monthly) CRON_SCHEDULE="0 0 1 * *" ;;
    yearly)  CRON_SCHEDULE="0 0 1 1 *" ;;
    *) echo "ERROR: Invalid Frequency Input" ;;
esac
CRON_JOB="$CRON_SCHEDULE /bin/bash $(pwd)/backup.bash 2>> $(pwd)/cron.log 2>&1
@reboot /bin/bash $(pwd)/backup.bash 2>> $(pwd)/cron.log "
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
echo "Cron job added successfully"
