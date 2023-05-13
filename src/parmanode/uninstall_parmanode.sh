function uninstall_parmanode {
set_terminal
echo "
########################################################################################

                                Uninstall Parmanode

    This will frist remove all programs associated with Parmanode and finally remove
    the Parmanode program and directories and configuration files.

########################################################################################
"
choose "epq"

exit_choice 
if [ $? == 1 ] ; then return 1 ; fi 
if grep -q "bitcoin" $HOME/.parmanode/installed.conf #checks if bitcoin is installed in install config file.
then uninstall_bitcoin 
else 
set_terminal


fi #ends if bitcoin installed/unsinstalled

set_terminal

if [[ $debug == 0 ]] ; then 
echo "
########################################################################################

                            Parmanode will be uninstalled

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
rm -rf $HOME/parmanode >/dev/null 2>&1

set_terminal
echo "
########################################################################################

                        Parmanode has been uninstalled

########################################################################################
"
previous_menu
return 0
}
