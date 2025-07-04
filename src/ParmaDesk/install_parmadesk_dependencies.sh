function install_parmadesk_dependencies {
# Dependencies
server="tightvncserver"

sudo apt-get update && export APT_UPDATE="true"

#purge to avoid conflicts
sudo apt purge tigervnc-standalone-server tigervnc-common -y

sudo apt install -y mate-desktop-environment xfce4 xfce4-goodies novnc websockify xfwm4 x11-xserver-utils xfce4-terminal dbus-x11 $server 

}
