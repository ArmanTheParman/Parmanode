function uninstall_parmanode {

set_terminal

while true ; do
echo -e "
########################################################################################
$red
                                Uninstall Parmanode??
$orange
    This will first give you the option to remove programs installed with Parmanode 
    before removing the Parmanode installation files and configuration files. 
    
    Finally, you'll have the option to delete the Parmanode script directory.

    Continue?
$red
                        y)        Get rid of it
$green
                        n)        Nah, go back
$orange
########################################################################################
"
choose "epmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y|yes|YES|Y) break ;;
*) invalid ;;
esac
done



if grep -q "bitcoin" $ic #checks if bitcoin is installed in install config file.
then uninstall_bitcoin #confirmation inside function 
set_terminal
else 
set_terminal
fi #ends if bitcoin installed/unsinstalled

if grep -q "fulcrum" $ic 
then uninstall_fulcrum #both linux & mac, confirmations inside functions
set_terminal
fi

if grep -q "btcpay" $ic 
then uninstall_btcpay # confirmation inside function, linux and mac.
set_terminal
fi

if grep -q "electrum-" $ic
then
uninstall_electrum
set_terminal
fi

if grep -q "lnd" $ic ; then
uninstall_lnd
set_terminal
fi


if grep -q "rtl" $ic
then
uninstall_rtl #Confirmation inside function
set_terminal
fi

if grep -q "sparrow" $ic
then
uninstall_sparrow
set_terminal
fi

if grep -q "tor-server" $ic
then
uninstall_tor_webserver
set_terminal
fi

if grep -q "specter" $ic
then
uninstall_specter
set_terminal
fi

if grep -q "electrs-" $ic
then
uninstall_electrs
set_terminal
fi

if grep -q "btcrpcexplorer" $ic
then
uninstall_btcrpcexplorer
set_terminal
fi

if grep -q "parmanshell" $ic
then
uninstall_parmanshell
set_terminal
fi

if grep -q "X11" $ic
then
uninstall_X11
set_terminal
fi

if [[ -e $hp/parman_books ]] ; then
yesorno "Remove Parman_Books?" && rm -rf $hp/parman_books
set_terminal
fi

if grep -q "green" $ic ; then
uninstall_green
set_terminal
fi

if grep -q "joinmarket" $ic ; then
uninstall_joinmarket
set_terminal
fi

if grep -q "btcrecover" $ic ; then
uninstall_btcrecover
set_terminal
fi

if grep -q "parmanostr" $ic ; then
uninstall_parmanostr
set_terminal
fi

if grep -q "nextclour" $ic ; then
uninstall_nextcloud
set_terminal
fi
if grep -q "litd" $ic ; then
uninstall_litd
set_terminal
fi

if grep -q "nostrrelay" $ic ; then
uninstall_nostrrelay
set_terminal
fi
if grep -q "litd" $ic ; then
uninstall_litd
set_terminal
fi
if grep -q "parmaweb" $ic ; then
uninstall_parmaweb
set_terminal
fi
if grep -q "thunderhub" $ic ; then
uninstall_thunderhub
set_terminal
fi
if grep -q "electrumx" $ic ; then
uninstall_electrumx
set_terminal
fi
if grep -q "public_pool" $ic ; then
uninstall_public_pool
set_terminal
fi
if grep -q "torssh" $ic ; then
uninstall_torssh
set_terminal
fi
if grep -q "mempool" $ic ; then
uninstall_mempool
set_terminal
fi
if grep -q "qbittorrent" $ic ; then
uninstall_qbittorrent
set_terminal
fi
if grep -q "torb" $ic ; then
uninstall_torbrowser
set_terminal
fi
if grep -q "torrelay" $ic ; then
uninstall_torrelay
set_terminal
fi
if grep -q "pihole" $ic ; then
uninstall_pihole
set_terminal
fi
if grep -q "anydesk" $ic ; then
uninstall_anydesk
set_terminal
fi
if grep -q "parmabox" $ic ; then
uninstall_parmabox
set_terminal
fi
if grep -q "ledger" $ic ; then
uninstall_ledger
set_terminal
fi
if grep -q "bitbox" $ic ; then
uninstall_bitbox
set_terminal
fi
if grep -q "trezor" $ic ; then
uninstall_trezor
set_terminal
fi
if grep -q "lnbits" $ic ; then
uninstall_lnbits
set_terminal
fi
if grep -q "vaultwarden" $ic ; then
uninstall_vaultwarden
set_terminal
fi



#### Premium apps
if grep -q "parmascale" $ic ; then
uninstall_parmascale
set_terminal
fi
if grep -q "uddns" $ic ; then
uninstall_uddns
set_terminal
fi
if grep -q "parminer" $ic ; then
uninstall_parminer
set_terminal
fi
if grep -q "parmacloud" $ic ; then
uninstall_parmacloud
set_terminal
fi
if grep -q "parmaswap" $ic ; then
uninstall_parmaswap
set_terminal
fi
if grep -q "datum" $ic ; then
uninstall_datum
set_terminal
fi
if grep -q "parmasync" $ic ; then
uninstall_parmasync
set_terminal
fi

set_terminal
if [[ $debug == 0 ]] ; then 
while true ; do
clear
echo -e "
########################################################################################
$red
                            Parmanode will be uninstalled
$orange
########################################################################################
"
choose "epmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
m|M) back2main ;; q|Q) exit ;; p|P) return 1 ;; "") break ;; *) invalid ;; 
esac
done
unset choice
fi

#check other programs are installed in later versions.

if [[ $OS == "Linux" ]] ; then

        if [[ $EUID -eq 0 ]] ; then  #if user running as root, sudo causes command to fail.
                umount /media/$HOME/parmanode* > $dn 2>&1
            else
                sudo umount /media/$HOME/parmanode* > $dn 2>&1
            fi
    fi

    if [[ $OS == "Mac" ]] ; then

        disktultil unmount "parmanode"

        fi

#remove bind mount
sudo unmount $wwwparmaviewdir

#uninstall parmanode directories and config files contained within.
sudo rm -rf $HOME/.parmanode >$dn 2>&1

#removes all parmanode crontab entries
autoupdate off

cleanup_bashrc_zshrc

set_terminal ; echo -e "
########################################################################################

    Do you also wish to delete the Parmanode$cyan script directory$orange 

                                   y)    Yes

                                   n)    No

    If you choose yes, then this program will continue to run from computer memory, 
    but you won't be able to start it up again unless you install it again.

######################################################################################## 
"
read choice
case $choice in y|Y) 
#remove desktop icon file
rm $HOME/Desktop/*un_parmanode* >$dn
rm $HOME/Desktop/*armanode* >$dn
rm $HOME/Desktop/parmanode.desktop >$dn
rm $HOME/.icons/PNicon*
sudo rm -rf $pn
;;
esac

set_terminal
echo -e "
########################################################################################

                        Parmanode has been uninstalled       
                                                                       $red Happy now? $orange
########################################################################################
"
sleep 3
exit
}
