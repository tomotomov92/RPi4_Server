#Change password
passwd pi #sudo passwd pi


#Change hostname:
raspi-config nonint do_hostname raspserver #sudo raspi-config nonint do_hostname raspserver


#Set Timezone to Sofia
timedatectl set-timezone Europe/Sofia #sudo timedatectl set-timezone Europe/Sofia


#Disable Swap file
dphys-swapfile swapoff #sudo dphys-swapfile swapoff
systemctl disable dphys-swapfile.service #sudo systemctl disable dphys-swapfile.service


#Create backup directory
mkdir -p /backup #sudo mkdir -p /backup


#Install ccrypt
apt install ccrypt -y #sudo apt install ccrypt


#Install Argon One case script for FAN
curl https://download.argon40.com/argon1.sh | bash


#Update && Upgrade
apt update && apt upgrade -y #sudo apt update && sudo apt upgrade -y


#Create directory for mount
mkdir -p /mnt/ExternalStorage #sudo mkdir -p /mnt/ExternalStorage
chown -R pi:pi /mnt/ExternalStorage #sudo chown -R pi:pi /mnt/ExternalStorage


#Add drive to /mnt on startup
sed -i -e '$aUUID=441228F01228E91E /mnt/ExternalStorage ntfs defaults,nofail,noatime 0 0' /etc/fstab #sudo sed -i -e '$aUUID=441228F01228E91E /mnt/ExternalStorage ntfs defaults,nofail,noatime 0 0' /etc/fstab


#Docker
apt install docker -y #sudo apt install docker -y


#Docker-Compose
apt install docker-compose -y #sudo apt install docker-compose -y


#Configure Docker
usermod -aG docker pi #sudo usermod -aG docker pi
su pi #sudo su pi


#Samba
#Install SAMBA:
apt install samba samba-common-bin -y #sudo apt install samba samba-common-bin -y
#Append at the end of the samba config:
sed -i -e '$a[ExternalStorage]' /etc/samba/smb.conf #sudo sed -i -e '$a[ExternalStorage]' /etc/samba/smb.conf
sed -i -e '$a  comment = Storage share' /etc/samba/smb.conf #sudo sed -i -e '$a  comment = Storage share' /etc/samba/smb.conf
sed -i -e '$a  path = /mnt/ExternalStorage' /etc/samba/smb.conf #sudo sed -i -e '$a  path = /mnt/ExternalStorage' /etc/samba/smb.conf
sed -i -e '$a  browseable = yes' /etc/samba/smb.conf #sudo sed -i -e '$a  browseable = yes' /etc/samba/smb.conf
sed -i -e '$a  writeable = yes' /etc/samba/smb.conf #sudo sed -i -e '$a  writeable = yes' /etc/samba/smb.conf
sed -i -e '$a  public = yes' /etc/samba/smb.conf #sudo sed -i -e '$a  public = yes' /etc/samba/smb.conf
sed -i -e '$a  guest ok = yes' /etc/samba/smb.conf #sudo sed -i -e '$a  guest ok = yes' /etc/samba/smb.conf
sed -i -e '$a  guest only = no' /etc/samba/smb.conf #sudo sed -i -e '$a  guest only = no' /etc/samba/smb.conf
sed -i -e '$a  create mask = 0777' /etc/samba/smb.conf #sudo sed -i -e '$a  create mask = 0777' /etc/samba/smb.conf
sed -i -e '$a  directory mask = 0777' /etc/samba/smb.conf #sudo sed -i -e '$a  directory mask = 0777' /etc/samba/smb.conf
sed -i -e '$a  read only = no' /etc/samba/smb.conf #sudo sed -i -e '$a  read only = no' /etc/samba/smb.conf
  

#Plex
#Enter Super User for the execution of Plex
su #sudo su
#Add key to access installation and updates for the project
curl https://downloads.plex.tv/plex-keys/PlexSign.key | apt-key add -
#Download the packages from plex's website to the local storage 
echo deb https://downloads.plex.tv/repo/deb public main | tee /etc/apt/sources.list.d/plexmediaserver.list
#Exit the Super User
exit
#Update the references
apt update #sudo apt update
#Install Plex with apt as usual
apt install plexmediaserver #sudo apt install plexmediaserver


#Append cron jobs to pi's crontab for daily updates and backups
sed -i -e '$a0 0 * * * sudo /usr/bin/sh /home/pi/update.sh >> /home/pi/update.log' /var/spool/cron/crontabs/pi #sudo sed -i -e '$a0 0 * * * sudo /usr/bin/sh /home/pi/update.sh >> /home/pi/update.log' /var/spool/cron/crontabs/pi
sed -i -e '$a0 1 * * * sudo /usr/bin/sh /home/pi/backup.sh' /var/spool/cron/crontabs/pi #sudo sed -i -e '$a0 1 * * * sudo /usr/bin/sh /home/pi/backup.sh' /var/spool/cron/crontabs/pi


#Create Telegraf directory and import the components
mkdir -p /var/lib/telegraf #sudo mkdir -p /var/lib/telegraf
nano /var/lib/telegraf/telegraf.conf #sudo nano /var/lib/telegraf/telegraf.conf

[global_tags]

[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  hostname = "raspserver"
  omit_hostname = false

[[outputs.influxdb]]
urls = ["http://192.168.2.16:8086"]
database = "telegraf"
timeout = "5s"


[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false


[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs"]

[[inputs.diskio]]

[[inputs.kernel]]

[[inputs.mem]]

[[inputs.processes]]

[[inputs.swap]]

[[inputs.system]]

[[inputs.net]]
