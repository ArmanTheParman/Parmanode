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