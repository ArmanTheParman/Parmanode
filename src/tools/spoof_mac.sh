function spoof_mac {
if [[ $OS == "Mac" ]] ; then nomac ; return 1 ; fi

if sudo test -f /etc/NetworkManager/conf.d/20-parmanode-spoof_mac.conf >$dn 2>&1 ; then
yesorno "the$green Spoof MAC Tool$orange is already installed, do you want to uninstall it?" || return 1
sudo rm /etc/NetworkManager/conf.d/20-parmanode-spoof_mac.conf >$dn 2>&1 
return 0
fi

yesorno "The$green Spoof MAC Tool$orange creates a fake temporary and random MAC (Media Access Control) 
    address for Ethernet or WiFi hardware, which can help fight against tracking and 
    improve your privacy online. 
    
    Installing this will result in a new MAC address whenever you switch off then 
    on your WiFi or Ethernet hardware. Eg (click 'WiFi' off, or 'Wired' off, or
    unplug and replug your Ethernet cable)." || return 1
    

cat<<EOF | sudo tee /etc/NetworkManager/conf.d/20-parmanode-spoof_mac.conf >$dn
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
EOF
}
