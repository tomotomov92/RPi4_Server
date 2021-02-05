#!/bin/bash

# Create the final directory for the backups
mkdir -p /mnt/ExternalStorage/Backups/$(hostname)_$(date +"%Y%m%d")


# Backup system config directories
tar -zcf /backup/system.tgz \
 --exclude=".*" \
 --exclude="/home/pi/*.log" \
 --add-file=/boot/config.txt
 -c /etc/dnsmasq.d \
 -c /etc/samba \
 -c /home \
 -c /var/lib/duckdns \
 -c /var/lib/duplicati \
 -c /var/lib/pihole \
 -c /var/lib/portainer \
 -c /var/lib/samba \
 -c /var/lib/wireguard \
 -c /var/spool/cron/crontabs
 /
# Move the archive to external storage for backing up
mv /backup/system.tgz /mnt/ExternalStorage/Backups/$(hostname)_$(date +"%Y%m%d")/system.tgz


# Backup database config directories
tar -zcf /backup/databases.tgz \
 -c /var/lib/chronograf \
 -c /var/lib/mysql
 /
# Move the archive to external storage for backing up
mv /backup/databases.tgz /mnt/ExternalStorage/Backups/$(hostname)_$(date +"%Y%m%d")/databases.tgz


# Backup monitoring config directories
tar -zcf /backup/monitoring.tgz \
 -c /etc/motioneye \
 -c /var/lib/grafana \
 -c /var/lib/motioneye \
 -c /var/lib/telegraf \
 -c /var/run/motion
 /
# Move the archive to external storage for backing up
mv /backup/monitoring.tgz /mnt/ExternalStorage/Backups/$(hostname)_$(date +"%Y%m%d")/monitoring.tgz


# Backup downloaders config directories
tar -zcf /backup/downloaders.tgz \
 -c /var/lib/nzbget \
 -c /var/lib/transmission \
 -c /var/lib/jackett
 /
# Move the archive to external storage for backing up
mv /backup/downloaders.tgz /mnt/ExternalStorage/Backups/$(hostname)_$(date +"%Y%m%d")/downloaders.tgz


# Backup media config directories
sudo tar -zcf /backup/media.tgz \
 --exclude='/var/lib/ombi/Logs/*' \
 --exclude='/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Cache/*' \
 --exclude='/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Logs/*' \
 --exclude='/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Media/*' \
 --exclude='/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Metadata/*' \
 --exclude='/var/lib/radarr/config/logs/*' \
 --exclude='/var/lib/radarr/config/MediaCover/*' \
 --exclude='/var/lib/sonarr/logs/*' \
 --exclude='/var/lib/sonarr/MediaCover/*' \
 -c /var/lib/bazarr \
 -c /var/lib/ombi \
 -c /var/lib/plexmediaserver \
 -c /var/lib/radarr \
 -c /var/lib/sonarr
 /
# Move the archive to external storage for backing up
mv /backup/media.tgz /mnt/ExternalStorage/Backups/$(hostname)_$(date +"%Y%m%d")/media.tgz


#Encrypt all archives
ccencrypt -K  /mnt/ExternalStorage/Backups/$(hostname)_$(date +"%Y%m%d")/*.*
