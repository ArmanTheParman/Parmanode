function ParmanodL_chroot {
if [[ $OS == Linux ]] ; then 
sudo chroot /tmp/mnt/raspi /bin/bash -c "apt-get update -y && apt-get upgrade -y "
sudo chroot /tmp/mnt/raspi /bin/bash -c "apt-get install vim -y" 
sudo chroot /tmp/mnt/raspi /bin/bash -c "groupadd -r parman ; useradd -m -g parman parman ; usermod -aG sudo parman"
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "parman:parmanodl" | chpasswd ; systemctl enable ssh'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'chage -d 0 parman' 
sudo chroot /tmp/mnt/raspi /bin/bash -c "apt-get purge piwiz -y" 
sudo chroot /tmp/mnt/raspi /bin/bash -c 'userdel rpi-first-boot-wizard'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'userdel pi'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'rm -rf /home/pi /home/rpi*'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "Defaults lecture=never" >> /etc/sudoers'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "" > /etc/motd'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'sed -i "/autologin-user=/d" /etc/lightdm/lightdm.conf' 
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "PrintLastLog no" >> /etc/ssh/sshd_config'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'rfkill unblock wifi'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "" > /etc/ssh/sshd_config.d/rename_user.conf'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/parmanode /home/parman/.parmanode'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/parman_programs/parmanode'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "message_instructions=1" > /home/parman/.parmanode/hide_messages.conf'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanode-start" > /home/parman/.parmanode/installed.conf'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanode-end" > /home/parman/.parmanode/installed.conf'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanodl" > /etc/hostname'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'apt-get install git -y'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'cd /home/parman/parman_programs/ ; git clone https://github.com/armantheparman/parmanode.git'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'cat /etc/shadow | grep parman > /tmp/oldPassword'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'chown -R parman:parman /home/parman' #necessary


echo '

WELCOME TO YOUR ...

.______      ___      .______   .___  ___.      ___      .__   __.   ______    _______    __      
|   _  \    /   \     |   _  \  |   \/   |     /   \     |  \ |  |  /  __  \  |   __  \  |  |     
|  |_)  |  /  ^  \    |  |_)  | |  \  /  |    /  ^  \    |   \|  | |  |  |  | |  T  |  | |  |     
|   ___/  /  /_\  \   |      /  |  |\/|  |   /  /_\  \   |  `    | |  |  |  | |  |  |  | |  |     
|  |     /  _____  \  |  |\  \  |  |  |  |  /  /   \  \  |  | `  | |  |__|  | |  |__|  | |  |____
| _|    /__/     \__\ | _| `._\ |__|  |__| /__/     \__\ |__| \__|  \______/  |_______/  |_______|
                                                                                         v2.0.0                                                                                 

... computer, running pre-installed Parmanode software.

Type "menu" to use the program.

First time use - the password needs to be changed, then it exits. Then come back.
	

' > /tmp/banner.txt
sudo cp /tmp/banner.txt /tmp/mnt/raspi/tmp/banner.txt
sudo chroot /tmp/mnt/raspi /bin/bash -c 'cat /tmp/banner.txt > /etc/motd'
rm /tmp/banner.txt

cat << 'EOF' > /tmp/menu
#!/bin/bash
oldPassword=$(cat /tmp/oldPassword) ; if sudo cat /etc/shadow | grep -q "$oldPassword" ; then sudo sed -i '/First/d' /etc/motd ; sudo sed -i '/oldPassword/d' /usr/local/bin/menu ; fi 
cd /home/parman/parman_programs/parmanode/
./run_parmanode.sh
EOF

sudo mv /tmp/menu /tmp/mnt/raspi/home/parman/menu
sudo chroot /tmp/mnt/raspi /bin/bash -c 'chmod 755 /home/parman/menu'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'chown root:root /home/parman/menu'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'cd /home/parman ; mv menu /usr/local/bin/' 
fi


if [[ $OS == Mac ]] ; then

cat << 'EOS' > ~/ParmanodL/chroot_function.sh #document to be executed inside docker container.
#!/bin/bash

chroot /tmp/mnt/raspi /bin/bash -c "apt-get update -y && apt-get upgrade -y"
chroot /tmp/mnt/raspi /bin/bash -c "apt-get install vim -y" 
chroot /tmp/mnt/raspi /bin/bash -c "groupadd -r parman ; useradd -m -g parman parman ; usermod -aG sudo parman"
chroot /tmp/mnt/raspi /bin/bash -c 'echo "parman:parmanodl" | chpasswd ; systemctl enable ssh'
chroot /tmp/mnt/raspi /bin/bash -c 'chage -d 0 parman' 
chroot /tmp/mnt/raspi /bin/bash -c "apt-get purge piwiz -y" 
chroot /tmp/mnt/raspi /bin/bash -c 'userdel rpi-first-boot-wizard'
chroot /tmp/mnt/raspi /bin/bash -c 'userdel pi'
chroot /tmp/mnt/raspi /bin/bash -c 'rm -rf /home/pi /home/rpi*'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "Defaults lecture=never" >> /etc/sudoers'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "" > /etc/motd'
chroot /tmp/mnt/raspi /bin/bash -c 'sed -i "/autologin-user=/d" /etc/lightdm/lightdm.conf' 
chroot /tmp/mnt/raspi /bin/bash -c 'echo "PrintLastLog no" >> /etc/ssh/sshd_config'
chroot /tmp/mnt/raspi /bin/bash -c 'rfkill unblock wifi'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "" > /etc/ssh/sshd_config.d/rename_user.conf'
chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/parmanode /home/parman/.parmanode'
chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/parman_programs/parmanode'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "message_instructions=1" > /home/parman/.parmanode/hide_messages.conf'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanode-start" > /home/parman/.parmanode/installed.conf'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanode-end" > /home/parman/.parmanode/installed.conf'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanodl" > /etc/hostname'
chroot /tmp/mnt/raspi /bin/bash -c 'apt-get install git -y'
chroot /tmp/mnt/raspi /bin/bash -c 'cd /home/parman/parman_programs/ ; git clone https://github.com/armantheparman/parmanode.git'
chroot /tmp/mnt/raspi /bin/bash -c 'cat /etc/shadow | grep parman > /tmp/oldPassword'
chroot /tmp/mnt/raspi /bin/bash -c 'chown -R parman:parman /home/parman' #necessary


echo '

WELCOME TO YOUR ...

.______      ___      .______   .___  ___.      ___      .__   __.   ______    _______    __      
|   _  \    /   \     |   _  \  |   \/   |     /   \     |  \ |  |  /  __  \  |   __  \  |  |     
|  |_)  |  /  ^  \    |  |_)  | |  \  /  |    /  ^  \    |   \|  | |  |  |  | |  T  |  | |  |     
|   ___/  /  /_\  \   |      /  |  |\/|  |   /  /_\  \   |  `    | |  |  |  | |  |  |  | |  |     
|  |     /  _____  \  |  |\  \  |  |  |  |  /  /   \  \  |  | `  | |  |__|  | |  |__|  | |  |____
| _|    /__/     \__\ | _| `._\ |__|  |__| /__/     \__\ |__| \__|  \______/  |_______/  |_______|
                                                                                         v2.0.0                                                                                 

... computer, running pre-installed Parmanode software.

Type "menu" to use the program.

First time use - the password needs to be changed, then it exits. Then come back.
	

' > /tmp/banner.txt
cp /tmp/banner.txt /tmp/mnt/raspi/tmp/banner.txt
chroot /tmp/mnt/raspi /bin/bash -c 'cat /tmp/banner.txt > /etc/motd'
rm /tmp/banner.txt

cat << 'EOF' > /tmp/menu
#!/bin/bash
oldPassword=$(cat /tmp/oldPassword) ; if sudo cat /etc/shadow | grep -q "$oldPassword" ; then sudo sed -i '/First/d' /etc/motd ; sudo sed -i '/oldPassword/d' /usr/local/bin/menu ; fi 
cd /home/parman/parman_programs/parmanode/
./run_parmanode.sh
EOF

mv /tmp/menu /tmp/mnt/raspi/home/parman/menu
chroot /tmp/mnt/raspi /bin/bash -c 'chmod 755 /home/parman/menu'
chroot /tmp/mnt/raspi /bin/bash -c 'chown root:root /home/parman/menu'
chroot /tmp/mnt/raspi /bin/bash -c 'cd /home/parman ; mv menu /usr/local/bin/ '
EOS # ends heredoc
sudo chmod +x ~/ParmanodL/chroot_function.sh

docker exec -it ParmanodL /bin/bash -c '/mnt/ParmanodL/chroot_function.sh'

fi # end if Mac
}