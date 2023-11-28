function start_qbittorrent {

if [[ $OS == Mac ]] ; then
open /Applications/qbittorrent.app 

elif [[ $computer_type == LinuxPC ]] ; then
nohup $hp/qbittorrent/qbittorrent*AppImage >dev/null 2>&1 &

else
announce "Not supported for your OS, sorry." && return 1

fi
}