function install_novnc_dependencies {
# Dependencies
if [[ $debug == 1 ]] ; then
server="tigervnc-standalone-server tigervnc-common"
sudo apt purge tightvncserver tightvncpasswd -y
else
server="tightvncserver"
sudo apt purge tigervnc-standalone-server tigervnc-common -y
fi

sudo apt-get update
sudo apt install -y xfce4 xfce4-goodies novnc websockify xfwm4 x11-xserver-utils xfce4-terminal dbus-x11 $server 

}
