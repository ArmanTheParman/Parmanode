function install_torbrowser {

cd $hp
curl -LO https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.5.1/tor-browser-linux64-12.5.1_ALL.tar.xz
installed_conf_add "torb-start"
curl -LO https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.5.1/tor-browser-linux64-12.5.1_ALL.tar.xz.asc 

if gpg --verify --status-fd 1 tor*asc 2>&1 | grep -q GOOD ; then
announce "GPG verification passed."
esle
announce "GPG verification failed. Aborting."
return 1 
fi

tar -xvf tor* 
cd tor-browser/Browser
sudo chmod +x start-tor-browser.desktop

installed_conf_add "torb-end"
success "Tor Browser" "being installed"
./start-tor-browser.desktop
}