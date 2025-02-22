## Change hostname and timezone:
sudo raspi-config nonint do_hostname raspserver
sudo timedatectl set-timezone Europe/Sofia

## Create the necessary directories and permissions
sudo mkdir -p /backups
sudo mkdir -p /backup_temp
sudo mkdir -p /docker
sudo chown -R tomo:tomo /backups
sudo chown -R tomo:tomo /backup_temp
sudo chown -R tomo:tomo /docker
sudo chmod -R 700 /backups
sudo chmod -R 700 /backup_temp
sudo chmod -R 700 /docker

## Update apt
sudo apt update && sudo apt upgrade -y

## Install Docker
curl -sSL https://get.docker.com | sh
## Add user to docker group
sudo usermod -aG docker $USER

## Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --advertise-exit-node --ssh

#Add cron task for backing up every two days:
crontab -e
0 1 */2 * * sudo /usr/bin/sh /home/tomo/backup.sh
#0 * * * * sudo dhcpcd eth0 #Task for restoring eth0 connectivity once per hour


#Extract archive
sudo tar -C / -zxf /backups/backup.tgz 
