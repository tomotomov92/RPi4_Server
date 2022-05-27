#Change hostname and timezone:
sudo raspi-config nonint do_hostname raspserver
sudo timedatectl set-timezone Europe/Sofia

#Create directories and give tomo permissions:
sudo mkdir -p /backup
sudo mkdir -p /docker
sudo mkdir -p /downloads
sudo mkdir -p /storage
#Change owner
sudo chown -R tomo:tomo /backup
sudo chown -R tomo:tomo /docker
sudo chown -R tomo:tomo /downloads
sudo chown -R tomo:tomo /storage
#Add permissions to directories
sudo chmod -R 777 /backup
sudo chmod -R 777 /docker
sudo chmod -R 777 /downloads
sudo chmod -R 777 /storage

#Install required software from apt:
sudo apt update
sudo apt upgrade
sudo apt install smartmontools
sudo apt install samba samba-common-bin
sudo apt install docker
sudo apt install docker-compose

#Add permissions for default user to docker commands:
sudo usermod -aG docker tomo

#Add cron task for backing up every two days:
crontab -e
0 1 */2 * * sudo /usr/bin/sh /home/tomo/backup.sh
#0 * * * * sudo dhcpcd eth0 #Task for restoring eth0 connectivity once per hour

#Show hdd temperature
#sudo smartctl -A -d sat /dev/sda | grep Temperature_Celsius | awk '{print $10 " °C"}'
#sudo smartctl -A -d sat /dev/sdb | grep Temperature_Celsius | awk '{print $10 " °C"}'
#sudo smartctl -A -d sat /dev/sdc | grep Temperature_Celsius | awk '{print $10 " °C"}'
