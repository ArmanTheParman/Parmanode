function ParmanodL_chroot_docker {
#if modifying banner, don't use ', it will break the echo command.
#document to be executed inside docker container.
if [[ $debug == 1 ]] ; then
apt_text="#!/bin/bash
#chroot /tmp/mnt/raspi /bin/bash -c 'apt-get update -y'
"
else
apt_text="#!/bin/bash
#chroot /tmp/mnt/raspi /bin/bash -c 'apt-get update -y ; apt-get full-upgrade -y' 
"
fi

if [[ $arg2 == fast ]] ; then
cat << EOS > ~/ParmanodL/chroot_function.sh 
#!/bin/bash
EOS
else
cat << EOS > ~/ParmanodL/chroot_function.sh 
$apt_text
EOS
fi

cat << 'EOS' >> ~/ParmanodL/chroot_function.sh 
#####chroot /tmp/mnt/raspi /bin/bash -c "apt-get install vim -y" 
chroot /tmp/mnt/raspi /bin/bash -c "groupadd -r parman ; useradd -m -g parman parman ; usermod -aG sudo parman"
chroot /tmp/mnt/raspi /bin/bash -c 'echo "parman:parmanodl" | chpasswd ; systemctl enable ssh'
#####chroot /tmp/mnt/raspi /bin/bash -c 'chage -d 0 parman' 
chroot /tmp/mnt/raspi /bin/bash -c "apt-get purge piwiz -y" 
chroot /tmp/mnt/raspi /bin/bash -c 'userdel rpi-first-boot-wizard'
chroot /tmp/mnt/raspi /bin/bash -c 'userdel pi'
chroot /tmp/mnt/raspi /bin/bash -c 'rm -rf /home/pi /home/rpi*'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "Defaults lecture=never" >> /etc/sudoers'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "" > /etc/motd'
chroot /tmp/mnt/raspi /bin/bash -c 'sed -i "/autologin-user=/d" /etc/lightdm/lightdm.conf' 
chroot /tmp/mnt/raspi /bin/bash -c 'echo "PrintLastLog no" >> /etc/ssh/sshd_config'
chroot /tmp/mnt/raspi /bin/bash -c 'rfkill unblock wifi 2>/dev/null'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "" > /etc/ssh/sshd_config.d/rename_user.conf'
chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/parmanode /home/parman/.parmanode'
chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/parman_programs/parmanode'
chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/Desktop'
chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /media/parman/parmanode ; chown -R parman:parman /media/parman'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "message_instructions=1" > /home/parman/.parmanode/hide_messages.conf'
chroot /tmp/mnt/raspi /bin/bash -c 'echo "parmanodl" > /etc/hostname'
chroot /tmp/mnt/raspi /bin/bash -c "sed -i '/127.0.1.1/d' /etc/hosts"
chroot /tmp/mnt/raspi /bin/bash -c 'echo "127.0.1.1    parmanodl" | tee -a /etc/hosts'
chroot /tmp/mnt/raspi /bin/bash -c 'apt-get install git -y'
chroot /tmp/mnt/raspi /bin/bash -c 'cd /home/parman/parman_programs/ ; git clone https://github.com/armantheparman/parmanode.git'
####chroot /tmp/mnt/raspi /bin/bash -c 'mkdir -p /home/parman/.config/pcmanfm/LXDE-pi'
####chroot /tmp/mnt/raspi /bin/bash -c "echo 'wallpaper=/home/parman/parman_programs/parmanode/src/graphics/pn.png' | tee -a /home/parman/.config/pcmanfm/LXDE-pi/desktop-items-0.conf"
####chroot /tmp/mnt/raspi /bin/bash -c "echo 'wallpaper-mode fit' | tee -a /home/parman/.config/pcmanfm/LXDE-pi/desktop-items-0.conf"
####chroot /tmp/mnt/raspi /bin/bash -c "echo 'desktop_bg=#000000' | tee -a /home/parman/.config/pcmanfm/LXDE-pi/desktop-items-0.conf"

chroot /tmp/mnt/raspi /bin/bash -c 'chown -R parman:parman /home/parman' #necessary, and needed nearly last

echo '

WELCOME TO YOUR ...

 .______      ___      .______   .___  ___.      ___      .__   __.   ______    _______    __      
 |   _  \    /   \     |   _  \  |   \/   |     /   \     |  \ |  |  /  __  \  |   __  \  |  |     
 |  |_)  |  /  ^  \    |  |_)  | |  \  /  |    /  ^  \    |   \|  | |  |  |  | |  T  |  | |  |     
 |   ___/  /  /_\  \   |      /  |  |\/|  |   /  /_\  \   |  `    | |  |  |  | |  |  |  | |  |     
 |  |     /  _____  \  |  |\  \  |  |  |  |  /  /   \  \  |  | `  | |  |__|  | |  |__|  | |  |____
 | _|    /__/     \__\ | _| `._\ |__|  |__| /__/     \__\ |__| \__|  \______/  |_______/  |_______|
                                                                                             v3.0.0                                                                                 

... computer, running pre-installed Parmanode software.

Type rp to use the program (Stands for "run parmanode").

Please widen the screen manually if it does not ajust automatically.
	

' > /tmp/banner.txt
cp /tmp/banner.txt /tmp/mnt/raspi/tmp/banner.txt
chroot /tmp/mnt/raspi /bin/bash -c 'cat /tmp/banner.txt > /etc/motd'
rm /tmp/banner.txt

cat << 'EOF' > /tmp/rp
#!/bin/bash
cd /home/parman/parman_programs/parmanode/
./run_parmanode.sh
EOF
cp /tmp/rp /tmp/mnt/raspi/tmp/rp
rm /tmp/rp

cat << 'EOFF' > /tmp/instructions.txt

If you haven't already, please change your password from 'parmanodl'
to something else. You can use this command in Terminal (Terminal is
run by clicking that black icon on the taskbar):

    sudo passwd parman

(sudo means 'superuser do', 'passwd' is the command, and 'parman' is
the username that is having its password changed)

To run Parmanode, you can type 'rp' in the Terminal then <enter>. 

On the Pi, the Terminal doesn't automatically resize, so please widen the 
screen and make it taller using the mouse so the text doesn't wrap 
around and look ugly.

Read everything presented to you on the screen, take your time, and
it'll be easy.

If you use an external drive, sometimes, you'll get a 'not mounted' error when 
starting Bitcoin.  Make sure the drive is connected and you see its icon 
on the desktop. If not, unplug and replug it in. It should mount.

To adjust your settings, like keyboard layout, run:

sudo raspi-config

To access Parmanode from another computer on the network, type:

ssh parman@parmanodl.local

then the Pi's password. Notice, it is parmanodl.local, NOT parmanode.local.

If that doesn't work, you'll need the computer's IP address, which can
be a bit tricky to find. One way is to look it up on your router's
page, then do the command like this (example number shown):

ssh parman@192.168.0.100

Another way to find it is to run Parmanode, go to the tools menu and
choose ip.

You can use Parmanode to install various wallets - Sparrow or Electrum,
or Specter are the recommended ones. There others are for hardware
wallets, included to help you migrate yourself away from them (not
necessary but recommended).

Buy more Bitcoin.
If Parmanode is awesome, sned sats :)
Enjoy.
EOFF

sudo mv /tmp/instructions.txt /tmp/mnt/raspi/home/parman/Desktop/instructions.txt
chroot /tmp/mnt/raspi /bin/bash -c 'chown parman:parman /home/parman/Desktop/instructions.txt'


chroot /tmp/mnt/raspi /bin/bash -c 'chmod 755 /tmp/rp'
chroot /tmp/mnt/raspi /bin/bash -c 'chown parman:parman /tmp/rp'
chroot /tmp/mnt/raspi /bin/bash -c 'mv /tmp/rp /usr/local/bin/ '

cat << 'EOFFF' >/tmp/first_run.sh
pcmanfm --set-wallpaper /home/parman/parman_programs/parmanode/src/graphics/pn.png >/dev/null 2>&1
pcmanfm --wallpaper-mode fit >/dev/null 2>&1
sed -i "/desktop_bg=/c\\desktop_bg=#000000" /home/parman/.config/pcmanfm/LXDE-pi/desktop-items-0.conf >/dev/null 2>&1

rm /home/parman/first_run.sh >/dev/null 2>&1
sudo sed -i "/first_run.sh/d" ~/.profile >/dev/null 2>&1

EOFFF

sudo mv /tmp/first_run.sh /tmp/mnt/raspi/home/parman/first_run.sh
chroot /tmp/mnt/raspi /bin/bash -c 'chown -R parman:parman /home/parman/first_run.sh'
chroot /tmp/mnt/raspi /bin/bash -c 'chmod +x /home/parman/first_run.sh'
chroot /tmp/mnt/raspi /bin/bash -c "echo '/home/parman/first_run.sh' | tee -a /home/parman/.profile " >/dev/null

EOS

sudo chmod +x ~/ParmanodL/chroot_function.sh
docker exec -it ParmanodL /bin/bash -c '/mnt/ParmanodL/chroot_function.sh'
debug "pause and check chroot"
}


# had this before...
# chroot /tmp/mnt/raspi /bin/bash -c 'chown root:root /home/parman/rp'