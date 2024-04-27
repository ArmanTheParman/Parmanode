function make_ParmanodL_service {

#available in container at /mnt/ParmanodL
cp $HOME/parman_programs/parmanode/src/ParmanodL/parmanodl_gui $HOME/ParmanodL/parmanodl_gui


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
" | tee /tmp/parmanodl_gui.service 
mv /tmp/parmanodl_gui.service /tmp/mnt/raspi/etc/systemd/system/parmanodl_gui.service

mv /mnt/ParmanodL/parmanodl_gui /tmp/mnt/raspi/home/parman/.parmanode/parmanodl_gui
chroot /tmp/mnt/raspi /bin/bash -c 'chown -R parman:parman /home/parman/.parmanode'
chroot /tmp/mnt/raspi /bin/bash -c 'chmod +x /home/parman/.parmanode/parmanodl_gui'
chroot /tmp/mnt/raspi /bin/bash -c 'systemctl enable parmanodl_gui.service'

EOS
debug "check make_parmanodl_service added"
}