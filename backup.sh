#!/bin/bash

# Backup system config directories
tar -zcf /backup_temp/backup_$(hostname)_$(date +"%Y%m%d").tgz \
 --exclude=".*" \
 --exclude="/home/tomo/*.log" \
 -c /home/tomo/ \
 -c /docker/ 

# Move the archive to external storage for backing up
mv /backup_temp/backup_$(hostname)_$(date +"%Y%m%d").tgz /backups/backup_$(hostname)_$(date +"%Y%m%d").tgz

# Change backup permissions
chown tomo:tomo /backups/backup_$(hostname)_$(date +"%Y%m%d").tgz
chmod 777 /backups/backup_$(hostname)_$(date +"%Y%m%d").tgz

