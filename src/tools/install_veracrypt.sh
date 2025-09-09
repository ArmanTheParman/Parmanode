function install_veracrypt {

if [[ $(uname) == "Darwin" ]] ; then no_mac ; return 1 ; fi
apt_get_update
sudo apt-get install -y libwxgtk3.2-1 dmsetup 

#make directories and detect install start
mkdir $hp/veracrypt
installed_conf_add "veracrypt-start"
cd $hp/veracrypt

#download
curl -LO https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_1.26.24/VeraCrypt-1.26.24-x86_64.AppImage
curl -LO https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_1.26.24/VeraCrypt-1.26.24-x86_64.AppImage.sig

#verify
gpg --keyserver hkps://keys.openpgp.org --recv-keys 5069A233D55A0EEB174A5FC3821ACD02680D16DE
gpg --verify veracrypt*sig veracrypt*deb || { sww "PGP verification failed!" ; return 1 ; }

sudo chmod +x ./*.AppImage

install_conf_add "veracrypt-end"
success "VeraCrypt has been installed successfully!"
}

function uninstall_veracrypt {
    # code not finished
    rm -rf $hp/veracrypt
}

function menu_veracrypt {
while true ; do
set_terminal ; echo -e "
########################################################################################
                                 VeraCrypt Menu
########################################################################################

              
$cyan
              s)$orange             Start VeraCrypt (graphical)



########################################################################################
"
read choice ; set_terminal
jump $choice 
jump_pmq $choice || return 1
case $choice in
s) $hp/veracrypt/v*.AppImage
;;
esac
done
}
