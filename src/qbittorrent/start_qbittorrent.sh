function start_qbittorrent {

if [[ $OS == Mac ]] ; then
open /Applications/qbittorrent.app || announce "If you go a Nanny error from Mac OS, disallowing you to open the
    file, you need to open settings, go to security & privacy, and choose 'open anyway'."
elif [[ $computer_type == Linux ]] ; then
nohup $hp/qbittorrent/qbittorrent*AppImage >dev/null 2>&1 &
else
announce "Not supported for your OS, sorry." && return 1
fi
}