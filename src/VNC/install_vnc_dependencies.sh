function install_novnc_dependencies {
# Dependencies
sudo apt-get update
sudo apt install -y \
    tightvncserver \
    novnc \
    websockify \
    xfwm4 \
    xterm \
    x11-xserver-utils
}
