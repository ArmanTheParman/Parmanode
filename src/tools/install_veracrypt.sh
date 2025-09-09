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
gpg --verify *sig *AppImage || { sww "PGP verification failed!" ; return 1 ; }

sudo chmod +x ./*.AppImage

install_conf_add "veracrypt-end"
success "VeraCrypt has been installed successfully!"
}

function uninstall_veracrypt {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall VeraCrypt
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
esac
done
    rm -rf $hp/veracrypt
    installed_conf_remove "veracrypt"
    success "VeraCrypt uninstalled"
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
choose xpmq ; read choice ; set_terminal
jump $choice 
jump_pmq $choice || return 1
case $choice in
s) nohup $hp/veracrypt/*.AppImage >$dn 2>&1 & 
return
;;
esac
done
}
