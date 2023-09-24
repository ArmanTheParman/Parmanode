function make_dot_desktop {

echo "[Desktop Entry]
Type=Application
Name=Parmanode
Exec=$HOME/Desktop/run_parmanode.sh
Icon=$HOME/parmanode/icon.png
Terminal=true" | sudo tee ~/.local/share/applications/parmanode.desktop >/dev/null

debug "made make_dot_desktop"

cp $original_dir/src/graphics/icon.png $HOME/parmanode/

sudo chmod +x ~/.local/share/applications/parmanode.desktop
sudo update-icon-caches /usr/share/icons/* >/dev/null 2>&1

}
