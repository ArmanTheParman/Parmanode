function uninstall_parmanode {
set_terminal
echo "
########################################################################################

                                Uninstall Parmanode

    This will frist remove all programs associated with Parmanode and finally you'll
    be asked to confirm removing the Parmanode program and directories and 
    configuration files.

########################################################################################
"
choose "epq"
case $choice in

    q|QUIT|Q|quit)
    exit 0 ;;

    p|P)
    return 1 ;;

    esac

if grep -q "bitcoin" $HOME/.parmanode/installed.conf #checks if bitcoin is installed in install config file.
then uninstall_bitcoin #confirmation inside function 
else 
set_terminal
fi #ends if bitcoin installed/unsinstalled

if grep -q "fulcrum" $HOME/.parmanode/installed.conf
then uninstall_fulcrum #both linux & mac, confirmations inside functions
set_terminal
fi

if grep -q "btcpTOR" $HOME/.parmanode/installed.conf
then 
        #linux condition not required becuase btcpTOR for mac non-existent.
        uninstall_btcpay_tor
        set_terminal
fi

if grep -q "btcpay" $HOME/.parmanode/installed.conf
then uninstall_btcpay # confirmation inside function, linux and mac.
set_terminal
fi

if grep -q "docker" $HOME/.parmanode/installed.conf
then
    if [[ $OS == "Linux" ]] ; then uninstall_docker_linux ; fi #confirmation inside function
    if [[ $OS == "Mac" ]] ; then
        set_terminal
        echo "Uninstall docker for Mac? y or n. "
        echo ""
        read choice
        if [[ $choice == y ]] ; then uninstall_docker_mac ; fi
    fi
set_terminal
fi

if grep -q "electrum" $HOME/.parmanode/installed.conf
then
uninstall_electrum
set_terminal
fi

if grep-q "lnd" $HOME/.parmanode/installd.conf
then
uninstall_lnd
set_terminal
fi


if grep-q "rtl" $HOME/.parmanode/installd.conf
then
uninstall_rtl #Confirmation inside function
set_terminal
fi

if grep-q "sparrow" $HOME/.parmanode/installd.conf
then
uninstall_sparrow
set_terminal
fi

if grep-q "tor-server" $HOME/.parmanode/installd.conf
then
uninstall_tor_server
set_terminal
fi

set_terminal

if [[ $debug == 0 ]] ; then 
echo "
########################################################################################

                            Parmanode will be uninstalled

    Note: The directory $HOME/parmanode will be left in tact; you may wish to delete
    that yourself

########################################################################################
"
choose "epq"
exit_choice ; if [[ $? == 1 ]] ; then return 1 ; fi
unset choice
fi

#check other programs are installed in later versions.

if [[ $OS == "Linux" ]] ; then

        if [[ $EUID -eq 0 ]] ; then  #if user running as root, sudo causes command to fail.
                umount /media/$(whoami)/parmanode > /dev/null 2>&1
            else
                sudo umount /media/$(whoami)/parmanode > /dev/null 2>&1
            fi
    fi

    if [[ $OS == "Mac" ]] ; then

        disktultil unmount "parmanode"

        fi
#uninstall parmanode directories and config files contained within.
rm -rf $HOME/.parmanode >/dev/null 2>&1

set_terminal ; echo "
########################################################################################

    Do you also wish to delete the Parmanode script direcotry, the one you downloaded
    from GitHub?

                                   y)    Yes

                                   n)    No

    If you choose yes, then this program will continue to run from computer memory, 
    but you won't be able to start it up again unless you download it again.

######################################################################################## 
"
read choice
case $choice in y|Y) rm -rf $original_dir ;; esac

set_terminal
echo "
########################################################################################

                        Parmanode has been uninstalled

########################################################################################
"
previous_menu
return 0
}
