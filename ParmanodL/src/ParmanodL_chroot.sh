function ParmanodL_chroot {

set_locale ; set_keyboard ; set_wifi_country ; set_timezone 

sudo chroot /tmp/mnt/raspi /bin/bash -c "apt update -y && apt upgrade -y ; exit"
sudo chroot /tmp/mnt/raspi /bin/bash -c "apt install vim -y ; exit" 
sudo chroot /tmp/mnt/raspi /bin/bash -c "groupadd -r parman ; useradd -m -g parman parman ; usermod -aG sudo parman ; exit"
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "parman:parmanodl" | chpasswd ; systemctl enable ssh ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'chage -d 0 parman ; exit' 
sudo chroot /tmp/mnt/raspi /bin/bash -c "apt purge piwiz -y ; exit" 
sudo chroot /tmp/mnt/raspi /bin/bash -c 'userdel rpi-first-boot-wizard ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'userdel pi ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'rm -rf /home/pi /home/rpi* ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "Defaults lecture=never" >> /etc/sudoers ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "" > /etc/motd ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'sed -i "/autologin-user=/d" /etc/lightdm/lightdm.conf ; exit' 
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "PrintLastLog no" >> /etc/ssh/sshd_config ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'rfkill unblock wifi ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "" > /etc/ssh/sshd_config.d/rename_user.conf ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/parmanode /home/parman/.parmanode ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/parman_programs/parmanode ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "message_instructions=1" > /home/parman/.parmanode/hide_messages.conf ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanode-start" > /home/parman/.parmanode/installed.conf ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanode-end" > /home/parman/.parmanode/installed.conf ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanodl" > /etc/hostname ; exit'
sudo cp -r $HOME/parman_programs/parmanode/. /tmp/mnt/raspi/home/parman/parman_programs/parmanode/
sudo chroot /tmp/mnt/raspi /bin/bash -c 'chown -R parman:parman /home/parman ; exit'


echo '

WELCOME TO...

.______      ___      .______   .___  ___.      ___      .__   __.   ______    _______    __      
|   _  \    /   \     |   _  \  |   \/   |     /   \     |  \ |  |  /  __  \  |   __  \  |  |     
|  |_)  |  /  ^  \    |  |_)  | |  \  /  |    /  ^  \    |   \|  | |  |  |  | |  T  |  | |  |     
|   ___/  /  /_\  \   |      /  |  |\/|  |   /  /_\  \   |  `    | |  |  |  | |  |  |  | |  |     
|  |     /  _____  \  |  |\  \  |  |  |  |  /  /   \  \  |  | `  | |  |__|  | |  |__|  | |  |____
| _|    /__/     \__\ | _| `._\ |__|  |__| /__/     \__\ |__| \__|  \______/  |_______/  |_______|

                                         v2.0.0

TIPS:
      - Widen the window if needed.
      - "Parmanode" is the software; "Parmanodl" is the device it runs on.
      - Type "menu" or "run_parmanode" to use the program.
      - First time use - the password needs to be changed, then it exits. Then come back.
      - Enjoy
	

' > /tmp/banner.txt
sudo cp /tmp/banner.txt /tmp/mnt/raspi/tmp/banner.txt
sudo chroot /tmp/mnt/raspi /bin/bash -c 'cat /tmp/banner.txt > /etc/motd ; exit'
rm /tmp/banner.txt

cat << 'EOF' > /tmp/menu
#!/bin/bash
cd /home/parman/parman_programs/parmanode/
./run_parmanode.sh
EOF

sudo mv /tmp/menu /tmp/mnt/raspi/home/parman/menu
sudo chroot /tmp/mnt/raspi /bin/bash -c 'chmod 755 /home/parman/menu ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'chown root:root /home/parman/menu ; exit'
sudo cp /tmp/mnt/raspi/home/parman/menu /tmp/mnt/raspi/home/parman/run_parmanode
sudo chroot /tmp/mnt/raspi /bin/bash -c 'chown root:root /home/parman/run_parmanode ; exit'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'cd /home/parman ; mv menu /usr/local/bin/ ; mv run_parmanode /usr/local/bin/ ; exit'
}