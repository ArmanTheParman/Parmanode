function make_ParmanodL_service {

cat << 'EOS' >> ~/ParmanodL/chroot_function.sh 
echo "
[Unit]
Description=Parmanode_GUI_settings
After=graphical.target

[Service]
Type=simple

ExecStart=/home/parman/.parmanode/parmanodl_gui

User=parman
Group=parman

[Install]
WantedBy=multi-user.target
"| sudo tee /etc/system/systemd/parmanodl_gui.service >/dev/null 2>&1

cp /home/parman/parman_programs/parmanode/src/ParmanodL/parmanodl_gui /home/parman/.parmanode/parmanodl_gui
chown -R parman:parman /home/parman/.parmanode
chmod +x /home/parman/.parmanode/parmanodl_gui

systemctl enable parmanodl_gui.service >/dev/null 2>&1
EOS
debug "check make_parmanodl_service added"
}