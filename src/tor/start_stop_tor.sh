function start_tor {
if [[ $OS == Linux ]] ; then
sudo systemctl start tor >$dn
fi
if [[ $OS == Mac ]] ; then
brew services start tor >$dn
fi
}

function stop_tor {
if [[ $OS == Linux ]] ; then
sudo systemctl stop tor >$dn
fi
if [[ $OS == Mac ]] ; then
brew services stop tor >$dn
fi
}

function restart_tor {
if [[ $OS == Linux ]] ; then
sudo systemctl restart tor >$dn
fi
if [[ $OS == Mac ]] ; then
brew services restart tor >/dev/null
fi
}
