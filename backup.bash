#!/bin/bash
source ./config.txt
if [[ $? -ne 0 ]]; then
    echo 'First configure the system'
    exit 1;
fi
cd $BACKUP_FILE_PATH
sudo rm .recover.zip 2> /dev/null
if [[ $? -ne 0 ]]; then
    echo 'Initailizing folder for backup'
fi
sudo mkdir -p .recover
cd .recover
count=1
while true; do
    var_name="BACKUP_FOLDER$count"
    folder="${!var_name}"
    if [ -z "$folder" ]; then
        break
    fi
    echo "Copying from $folder to .recover..."
    sudo cp -r "$folder" . > /dev/null
    ((count++))
done
echo "Backup restored to $BACKUP_FILE_PATH/.recover"
cd ../
echo "creating your backup file in $BACKUP_FILE_PATH..."
sudo zip -r .recover.zip .recover > /dev/null
echo "Backup file created as .recover.zip"
sudo rm -rf .recover