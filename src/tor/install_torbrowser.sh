function install_torbrowser {
if [[ $OS == Mac ]] ; then announce "Not available for Mac. Easy enough to install yourself.
    Go to https://www.torproject.org
    
    Watch out for Mac OS blocking the download, if so, manually approve it." ; return 1 ; fi

clear
cd $hp
# if [[ $OS == Mac ]] ; then
# curl -LO https://www.torproject.org/dist/torbrowser/13.0.1/tor-browser-macos-13.0.1.dmg
# installed_conf_add "torb-start"
# curl -LO https://www.torproject.org/dist/torbrowser/13.0.1/tor-browser-macos-13.0.1.dmg.asc
# fi
#computer_type variable as LinuxPC includes Linux but excludes Pi's
if [[ $computer_type == LinuxPC ]] ; then
curl -LO https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.5.1/tor-browser-linux64-12.5.1_ALL.tar.xz
installed_conf_add "torb-start"
curl -LO https://github.com/TheTorProject/gettorbrowser/releases/download/linux64-12.5.1/tor-browser-linux64-12.5.1_ALL.tar.xz.asc 
fi
#import key
curl https://keys.openpgp.org/vks/v1/by-fingerprint/EF6E286DDA85EA2A4BA7DE684E2C6E8793298290 | gpg --import -
debug "Check import"

#verify signature
gpg --verify --status-fd 1 tor*asc > $tmp/tor_gpg_output.delete 2>&1 

if grep -iq "GOOD" $tmp/tor_gpg_output.delete ; then
announce "GPG verification$green passed$orange."
rm $tmp/tor_gpg_output.delete >$dn
else
debug "check output"
rm $tmp/tor_gpg_output.delete >$dn
announce "GPG verification$red failed$orange. Aborting."
return 1 
fi

#extract
# if [[ $OS == Mac ]] ; then
# hdiutil attach tor*.dmg
# sudo mv /Volumes/Tor*/Tor*.app /Applications
# hdiutil detach /Volumes/Tor*
# rm tor-bro*
# fi

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

