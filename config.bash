#!/bin/bash
echo -n "Enter path of folder/files which have to be backed up (separated by space): "
read folder_path
count=1
for folder in $folder_path
do
    echo "BACKUP_FOLDER$count=$folder" | tee -a config.txt > /dev/null
    ((count++))
done
echo -n "Enter path of backup file location: "
read backup_path
echo "BACKUP_FILE_PATH=$backup_path" | tee -a config.txt > /dev/null
echo -n "What time do you prefer for backup (daily, weekly, monthly, yearly): "
read backup_time
case $backup_time in
    daily)
        CRON_CMD="0 0 * * * /home/mridul/Desktop/backManager/backup.bash"
        ;;
    weekly)
        CRON_CMD="0 0 * * 0 /home/mridul/Desktop/backManager/backup.bash"
        ;;
    monthly)
        CRON_CMD="0 0 1 * * /home/mridul/Desktop/backManager/backup.bash"
        ;;
    yearly)
        CRON_CMD="0 0 1 1 * /home/mridul/Desktop/backManager/backup.bash"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
echo "BACKUP_TIME=$backup_time" | tee -a config.txt > /dev/null
(crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
echo "Backup scheduled successfully: $backup_time"