function install_novnc_dependencies {
# Dependencies
sudo apt-get update
if command -v startplasma-x11 >/dev/null; then
    export DESKTOP_CMD="startplasma-x11"
elif command -v mate-session >/dev/null; then
    export DESKTOP_CMD="mate-session"
else 
    sudo apt-get install -y xfce4 xfce4-goodies x11-xserver-utils 
    export DESKTOP_CMD="startxfce4"
fi
sudo apt-get install -y tightvncserver websockify novnc
}