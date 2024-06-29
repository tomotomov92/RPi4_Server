#Change hostname and timezone:
sudo raspi-config nonint do_hostname raspserver
sudo timedatectl set-timezone Europe/Sofia

#Create directories and give tomo permissions:
sudo mkdir -p /backups
sudo mkdir -p /backup_temp
sudo mkdir -p /docker

#Change owner
sudo chown -R tomo:tomo /backups
sudo chown -R tomo:tomo /backup_temp
sudo chown -R tomo:tomo /docker

#Add permissions to directories
sudo chmod -R 777 /backups
sudo chmod -R 777 /backup_temp
sudo chmod -R 777 /docker

#Install required software from apt:
sudo apt update
sudo apt upgrade
sudo apt install docker docker-compose -y

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale set --advertise-exit-node
sudo tailscale up --advertise-routes=192.168.2.0/24 --ssh --advertise-exit-node

#Add permissions for default user to docker commands:
sudo usermod -aG docker tomo

sudo reboot

#Add cron task for backing up every two days:
crontab -e
0 1 */2 * * sudo /usr/bin/sh /home/tomo/backup.sh
#0 * * * * sudo dhcpcd eth0 #Task for restoring eth0 connectivity once per hour
