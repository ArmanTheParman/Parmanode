function make_dot_desktop {

echo "[Desktop Entry]
Type=Application
Name=Parmanode
Exec=$HOME/Desktop/run_parmanode.pn
Icon=$HOME/.parmanode/icon.png
Terminal=true" | sudo tee ~/.local/share/applications/parmanode.desktop >/dev/null

mkdir $HOME/.parmanode 
cd $HOME/.parmanode 
curl -LOs https://parmanode.com/icon.png

sudo chmod +x ~/.local/share/applications/parmanode.desktop
sudo update-icon-caches /usr/share/icons/* >/dev/null 2>&1

}
