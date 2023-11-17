function install_torbrowser {
clear
cd $hp
curl -LO https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.5.1/tor-browser-linux64-12.5.1_ALL.tar.xz
installed_conf_add "torb-start"
curl -LO https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.5.1/tor-browser-linux64-12.5.1_ALL.tar.xz.asc 

#import key
curl -s https://openpgpkey.torproject.org/.well-known/openpgpkey/torproject.org/hu/kounek7zrdx745qydx6p59t9mqjpuhdf | gpg --import -

if gpg --verify --status-fd 1 tor*asc 2>&1 | grep -q GOOD ; then
announce "GPG verification passed."
else
announce "GPG verification failed. Aborting."
return 1 
fi

tar -xvf tor* 
rm tor-browser* #won't delete the director, no -rf

cd tor-browser/Browser
sudo chmod +x start-tor-browser.desktop
cp start-tor-b* $HOME/Desktop/

installed_conf_add "torb-end"
success "Tor Browser" "being installed"
./start-tor-browser.desktop
}

