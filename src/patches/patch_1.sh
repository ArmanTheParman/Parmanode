function patch_1 {

rm_after_before
turn_off_spotlight
fix_parmanode_conf
fix_services
fix_fstab
fix_autoupdate
add_rp_function
correct_old_installation

parmanode_conf_add "patch=1"
}

function rm_after_before {
rm $dp/after >/dev/null 2>&1
rm $dp/before >/dev/null 2>&1
}

function turn_off_spotlight {

if [[ $OS != Mac ]] ; then return 0 ; fi

if sudo mdutil -s $parmanode_drive | grep -q disabled ; then #checks status of spotlight on drive
   return 0
else
   sudo mdutil -i off $parmanode_drive >/dev/null 2>&1 #turns off spotlight
   sudo mdutil -E $parmanode_drive >/dev/null 2>&1 #erase existing spotlight index
fi
}

function fix_parmanode_conf {
delete_line "$dp/parmanode.conf" "nodejs-end" >/dev/null
if grep -q rtl_tor < $dp/parmanode.conf ; then
delete_line "$dp/parmanode.conf" "rtl_tor"
parmanode_conf_add "rtl_tor=true"
fi
}

function fix_services {

if [[ $(uname) == Darwin ]] ; then return 0 ; fi
if [[ ! -f /etc/systemd/system/lnd.service ]] ; then return ; fi

if grep -q "Wants=bitcoind.service" < /etc/systemd/system/lnd.service ; then

    if sudo systemctl status lnd.service >/dev/null 2>&1 ; then lndrunning=true ; sudo systemctsl stop lnd.service >/dev/null 2>&1 ; fi
    swap_string "/etc/systemd/system/lnd.service" "Wants=bitcoind.service" "BindsTo=bitcoind.service" && \
    sudo systemctl daemon-reload >/dev/null 2>&1 
    if [[ $lndrunning == true ]] ; then sudo systemctl start lnd.service >/dev/null 2>&1 ; fi

fi
}

function fix_fstab {

if [[ $OS == "Linux" ]] ; then

	if grep -q "parmanode" /etc/fstab | grep -q "defaults " ; then 
	# On any line about a parmanode drive,
	# if there is a space after defualts instead of a comma, then "nofail" is missing.
	# it needs to be there, so this fixes.

	    sudo cp /etc/fstab etc/fstab_backup_parmanode

	    sudo sed -i '/parmanode/ s/defaults /defaults,nofail /g' /etc/fstab >/dev/null 2>&1
	fi

fi
}

function fix_autoupdate {

source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1
if [[ $autoupdate == true ]] ; then
echo "30 3 * * *  [ -x $HOME/.parmanode/update_script.sh ] && $HOME/.parmanode/update_script.sh" | sudo tee -a /etc/crontab >/dev/null 2>&1
parmanode_conf_remove "autoupdate="
fi
}

function add_rp_function {
if [[ $(uname) == Darwin ]] ; then rc=zshrc ; fi
if [[ $(uname) == Linux ]] 
then 
    rc=bashrc
    if [[ ! -e $HOME/.bashrc ]] ; then touch $HOME/.bashrc ; fi 
fi

if [[ ! -e $HOME/.$rc ]] ; then touch $HOME/.$rc ; fi

if grep -q run_parmanode.sh < ~/.$rc ; then return 0 ; fi

if ! grep "#Added by Parmanode..." < $HOME/.$rc ; then
echo "#Added by Parmanode..." | tee -a ~/.$rc >/dev/null 2>&1
echo 'function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh $@ ; }' | tee -a ~/.$rc >/dev/null 2>&1
fi
}
function correct_old_installation {

if [[ -d $HOME/parman_programs/parmanode ]] ; then return 0 ; fi

mkdir $HOME/parman_program
mv $original_dir $HOME/parman_programs/
rm $HOME/Desktop/run_parmanode*
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull >/dev/null 2>&1

if [[ $OS == Linux ]] ; then
mkdir -p ~/Desktop ~/.icons/
cp $HOME/parman_programs/parmanode/src/graphics/pn_icon.png $HOME/.icons/PNicon.png
echo "[Desktop Entry]
Type=Application
Exec=gnome-terminal -- bash -c \"$HOME/parman_programs/parmanode/run_parmanode.sh\"
Name=Parmanode
Icon=$HOME/.icons/PNicon.png
Terminal=true
Path=$HOME/parman_programs/parmanode/
Categories=Utility;Application;" | sudo tee $HOME/Desktop/parmanode.desktop 
sudo chmod +x $HOME/Desktop/parmanode.desktop
sudo chown $USER:$(id -gn) $HOME/Desktop/parmanode.desktop
$HOME/run_parmanode/src/parmanode/add_rp_function.sh 
fi

if [[ $OS == Mac ]] ; then
#make desktop clickable icon...
if [ ! -e $HOME/Desktop/run_parmanode ] ; then
cat > $HOME/Desktop/run_parmanode << 'EOF'
#!/bin/bash
cd $HOME/parman_programs/parmanode/
./run_parmanode.sh
EOF
sudo chmod +x $HOME/Desktop/run_parmanode*
fi
fi

}