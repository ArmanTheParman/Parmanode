function stop_fulcrum {
if [[ $OS == Linux ]] ; then
stop_fulcrum_linux
fi
if [[ $OS == Mac ]] ; then
stop_fulcrum_docker
fi
}

function start_fulcrum {
if [[ $OS == Linux ]] ; then
start_fulcrum_linux
fi

if [[ $OS == Mac ]] ; then
start_fulcrum_docker
fi
}

function start_fulcrum_linux {
sudo systemctl start fulcrum.service
}

function stop_fulcrum_linux {
sudo systemctl stop fulcrum.service
}