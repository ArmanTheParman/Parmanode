function install_torbrowser {
clear
cd $hp
if [[ $OS == Mac ]] ; then
curl -LO https://www.torproject.org/dist/torbrowser/13.0.1/tor-browser-macos-13.0.1.dmg
installed_conf_add "torb-start"
curl -LO https://www.torproject.org/dist/torbrowser/13.0.1/tor-browser-macos-13.0.1.dmg.asc
fi
#computer_type variable as LinuxPC includes Linux but excludes Pi's
if [[ $computer_type == LinuxPC ]] ; then
curl -LO https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.5.1/tor-browser-linux64-12.5.1_ALL.tar.xz
installed_conf_add "torb-start"
curl -LO https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.5.1/tor-browser-linux64-12.5.1_ALL.tar.xz.asc 
fi

#import key
curl -s https://openpgpkey.torproject.org/.well-known/openpgpkey/torproject.org/hu/kounek7zrdx745qydx6p59t9mqjpuhdf | gpg --import -

#verify signature
if gpg --verify --status-fd 1 tor*asc 2>&1 | grep -q GOOD ; then
announce "GPG verification passed."
else
announce "GPG verification failed. Aborting."
return 1 
fi

#extract
if [[ $OS == Mac ]] ; then
hdiutil attach tor*.dmg
sudo mv /Volumes/Tor*.app /Applications
hdiutil detach /Volumes/Tor*
rm tor-bro*
fi

if [[ $computer_type == LinuxPC ]] ; then
tar -xvf tor*.xz
rm tor-browser* #won't delete the directory, no -rf
fi

#"install"
if [[ $computer_type == LinuxPC ]] ; then
cd tor-browser/
sudo chmod +x start-tor-browser.desktop
./start-tor-browser.desktop --register-app
fi

installed_conf_add "torb-end"
success "Tor Browser" "being installed"
}

