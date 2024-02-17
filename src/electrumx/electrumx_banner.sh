function electrumx_banner {
make_electrumx_banner
make_electrumx_torbanner
set_terminal ; echo -e "
########################################################################################
    
    The Banner file is what people will see when they connect to your Electrum X 
    server. Please feel free to change the contents. It is located at:
$cyan
    $hp/electrumx/banner.txt
    $orange
    If you enable Tor, the banner file is at:
$bright_blue
    $hp/electrumx/torbanner.txt
$orange
########################################################################################
"
enter_continue
}


function make_electrumx_banner {
echo "
Congratulations, you have connected to a Parmanode Electrum X Server.

Your IP address is not tracked, but regadless, you shouldn't trust this statement.

And...

GFY. 

No, I mean, have a nice day.
" | sudo tee $hp/electrumx/banner.txt >/dev/null 2>&1
}

function make_electrumx_torbanner {
echo "
This is a Parmanode Electrums X Server.
Go away.
" | tee $hp/electrumx/torbanner.txt >/dev/null 2>&1
}