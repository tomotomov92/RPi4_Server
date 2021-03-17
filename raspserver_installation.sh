#Change password
passwd pi #sudo passwd pi


#Change hostname:
raspi-config nonint do_hostname raspserver #sudo raspi-config nonint do_hostname raspserver


#Set Timezone to Sofia
timedatectl set-timezone Europe/Sofia #sudo timedatectl set-timezone Europe/Sofia


##Disable Swap file
#dphys-swapfile swapoff #sudo dphys-swapfile swapoff
#systemctl disable dphys-swapfile.service #sudo systemctl disable dphys-swapfile.service


#Create backup directory
mkdir -p /backup #sudo mkdir -p /backup


#Install ccrypt
apt install ccrypt -y #sudo apt install ccrypt


#Restore files for backup
cp /<pathToBackups>/* /backup/ #sudo cp /<pathToBackups>/* /backup/

#Decrypt backup files
ccdecrypt -K  /backup/*.* #sudo ccdecrypt -K  /backup/*.*

#Restore specific archives
cd /backup
tar -zxvf <fileName>.tgz -C / #sudo tar -zxvf <fileName>.tgz -C /


##Install Argon One case script for FAN
#curl https://download.argon40.com/argon1.sh | bash


#Update && Upgrade
apt update && apt upgrade -y #sudo apt update && sudo apt upgrade -y


#Create directory for mount
mkdir -p /mnt/ExternalStorage #sudo mkdir -p /mnt/ExternalStorage
chown -R pi:pi /mnt/ExternalStorage #sudo chown -R pi:pi /mnt/ExternalStorage


#Add drive to /mnt on startup
sed -i -e '$aUUID=441228F01228E91E /mnt/ExternalStorage ntfs defaults,nofail,noatime 0 0' /etc/fstab
#sudo sed -i -e '$aUUID=441228F01228E91E /mnt/ExternalStorage ntfs defaults,nofail,noatime 0 0' /etc/fstab


#Install SAMBA:
apt install samba samba-common-bin -y #sudo apt install samba samba-common-bin -y
#Edit SAMBA config:
#sudo nano /etc/samba/smb.conf
#Restart SAMBA:
#sudo systemctl restart smbd



#Install Privoxy:
apt install privoxy -y #sudo apt install privoxy -y



#Docker
apt install docker -y #sudo apt install docker -y


#Docker-Compose
apt install docker-compose -y #sudo apt install docker-compose -y


#Configure Docker
usermod -aG docker pi #sudo usermod -aG docker pi
su pi #sudo su pi



#Plex
#Add key to access installation and updates for the project
curl https://downloads.plex.tv/plex-keys/PlexSign.key | apt-key add -
#curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
#Download the packages from plex's website to the local storage 
echo deb https://downloads.plex.tv/repo/deb public main | tee /etc/apt/sources.list.d/plexmediaserver.list
#echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
#Update the references
apt update #sudo apt update
#Install Plex with apt as usual
apt install plexmediaserver #sudo apt install plexmediaserver
