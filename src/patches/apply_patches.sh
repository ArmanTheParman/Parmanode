function apply_patches {
#patches ; each patch adds variable to parmanode.conf, sourced higher up
#patch=n
#get $patch from parmanode.conf
temp_patch
openssh_patch
suggest_brew
suggest_tor
make_parmanode_tor_service  #makes parmanode tor onion address ; put in next patch
hello
debug "before patch sequence"

case $patch in 
1) 
debug "case1"
patch_2 ; patch_3 ; patch_4 ; patch_5 ; patch_6 ;;
2)
debug "case2"
patch_3 ; patch_4 ; patch_5 ; patch_6 ;;
3)
debug "case3"
patch_4 ; patch_5 ; patch_6 ;;
4)
debug "case4"
patch_5 ; patch_6 ;;
5)
debug "case5"
patch_6 ;;
6)
debug "case6"
return 0 ;;
*) 
patch_1 ; patch_2 ; patch_3 ; patch_4 ; patch_5 ; patch_6 ;; 
esac
debug "end apply_patches"
}


function cleanup_parmanode_service {

if [[ $OS == Linux ]] && [[ -e /etc/systemd/system/parmanode.service ]] ; then
sudo systemctl stop parmanode.service >$dn 2>&1
sudo systemctl disable parmanode.service >$dn 2>&1
sudo rm /etc/systemd/system/parmanode.service >$dn 2>&1
sudo systemctl daemon-reload >/dev/null 2>&1
parmanode_conf_remove "parmanode_service="
rm $HOME/.parmanode/parmanode_script.sh >/dev/null 2>&1
fi
if [[ $OS == Mac ]] ; then
parmanode_conf_remove "tor_script=done"
sudo rm $dp/tor_script.sh >/dev/null 2>&1
fi


}

function suggest_tor {

if which tor >$dn 2>&1 ; then return 0 ; fi
if grep -q "no_tor=1" < $hm ; then return 0 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################
    
    Parmanode has detected you don't have$cyan Tor$orange installed. It runs in the 
    background, and Parmanode makes use of it for various apps. It is recommended you 
    have it. 
         
    Would you like Parmanode to install it for you now?

$cyan                     
                     y)$orange        Yes, thanks
$cyan
                     n)$orange        No, but I might later
$cyan
                     nooo)$orange     No, and never ask again

########################################################################################
"
choose xq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; 
nooo) echo "no_tor=1" | tee -a $hm >$dn 2>&1 ; return 0 ;;
n) return 0 ;;
y) install_tor silent ; return 0 ;;
*) invalid ;;
esac
done
}