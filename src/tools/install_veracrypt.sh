function install_veracrypt {

if [[ $(uname) == "Darwin" ]] ; then no_mac ; return 1 ; fi
apt_get_update
apt-get install -y libwxgtk3.2-1 dmsetup

#make directories and detect install start
mkdir $hp/veracrypt
installed_conf_add "veracrypt-start"
cd $hp/veracrypt

#download
curl -LO https://launchpad.net/veracrypt/trunk/1.26.7/+download/veracrypt-1.26.7-Debian-13-amd64.deb
curl -LO https://launchpad.net/veracrypt/trunk/1.26.7/+download/veracrypt-1.26.7-Debian-13-amd64.deb.sig

#verify
gpg --keyserver keyserver.ubuntu.com --recv-keys 0x680D16DE 
gpg --verify veracrypt.deb.sig veracrypt.deb || { announce "PGP verification failed!" ; return 1 ; }

# Install the VeraCrypt package
dpkg -i veracrypt.deb
# Fix any missing dependencies
apt-get install -f -y

install_conf_add "veracrypt-end"
success "VeraCrypt has been installed successfully!"
}


function uninstall_veracrypt {
    # code not finished
    rm -rf $hp/veracrypt
}
