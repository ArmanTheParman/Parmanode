function start_tor {
if [[ $OS == Linux ]] ; then
sudo systemctl start tor >/dev/null
fi
if [[ $OS == Mac ]] ; then
brew services start tor >/dev/null
fi
}

function stop_tor {
if [[ $OS == Linux ]] ; then
sudo systemctl stop tor >/dev/null
fi
if [[ $OS == Mac ]] ; then
brew services stop tor >/dev/null
fi
}

function restart_tor {
if [[ $OS == Linux ]] ; then
sudo systemctl restart tor >/dev/null
fi
if [[ $OS == Mac ]] ; then
brew services restart tor >/dev/null
fi
}