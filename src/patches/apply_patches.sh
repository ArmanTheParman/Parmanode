function apply_patches { debugf
#patches ; each patch adds variable to parmanode.conf, sourced higher up
#patch=n
#get $patch from parmanode.conf
temp_patch
suggest_tor
make_parmanode_tor_service  #makes parmanode tor onion address ; put in next patch
hello
#make sure debug file doesn't get too big
truncatedebuglog
if ! cat $bashrc 2>$dn | grep -q "parmashell_functions" ; then
echo "function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh \$@ ; }" | sudo tee -a $bashrc >$dn 2>&1
fi

#debug "before patch sequence - patch value is $patch"

case $patch in #case 0 is lase "*"
#1,2,3 removed, very unlikely cases now
4)
debug "case4"
patch_5 ; patch_6; patch_7 ; patch_8 ; patch_9 ; patch_10 ;;
5)
debug "case5"
patch_6 ; patch_7 ; patch_8 ; patch_9 ; patch_10 ;;
6)
debug "case6"
patch_7 ; patch_8 ; patch_9 ; patch_10 ;;
7)
debug "case7"
patch_8 ; patch_9 ; patch_10 ;;
8)
patch_9 ; patch_10
;;
9)
patch_10 
debug "patch 10 done"
;;
10)
return 0;;
*) 
patch_1 ; patch_2 ; patch_3 ; patch_4 ; patch_5 ; patch_6 ; patch_7 ; patch_8 ; patch_9 ; patch_10 ;;
esac
debug "end apply_patches :)"
}


function cleanup_parmanode_service {

if [[ $OS == "Linux" ]] && [[ -e /etc/systemd/system/parmanode.service ]] ; then
sudo systemctl stop parmanode.service >$dn 2>&1
sudo systemctl disable parmanode.service >$dn 2>&1
sudo rm /etc/systemd/system/parmanode.service >$dn 2>&1
sudo systemctl daemon-reload >$dn 2>&1
parmanode_conf_remove "parmanode_service="
rm $dp/parmanode_script.sh >$dn 2>&1
fi
if [[ $OS == "Mac" ]] ; then
parmanode_conf_remove "tor_script=done"
rm $dp/tor_script.sh >$dn 2>&1
fi


}

function suggest_tor {
if [[ $btcpayinstallsbitcoin == "true" ]] ; then return 0 ; fi
if [[ $btcdockerchoice == "yes" ]] ; then return 0 ; fi

if which tor >$dn 2>&1 ; then return 0 ; fi
if cat $hm 2>$dn | grep -q "no_tor=1" ; then return 0 ; fi

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