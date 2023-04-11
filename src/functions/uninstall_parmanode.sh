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

while true ; do
echo "
########################################################################################
    
                    Previou Bitcoin installation not detected
                         (excludes data direcotry check)

    Bitcoin doesn't appear to be installed according to the intstalltion 
    configuration file. This may not be 100% reliable. Would you like to go through 
    the Bitcoin uninstall procedure anyway, just in case? 
    
                                  (y)   yes 

                                  (s)   skip

########################################################################################    
"
choose "xpq" 
read choice

    case $choice in
    
    y|Y|yes|YES)
    uninstall_bitcoin
    break ;;

    s|S|skip|SKIP|Skip)
    break
    ;;

    p|P)
    return 1 ;;

    q|Q|Quit|QUIT)
    exit 0 ;;

    *)
    invalid 
    continue ;;
    esac

done
fi #ends if bitcoin installed/unsinstalled

set_terminal

echo "
########################################################################################

                            Parmanode will be uninstalled

########################################################################################
"
choose "epq"
exit_choice ; if [[ $? == 1 ]] ; then return 1 ; fi
unset choice
#check other programs are installed in later versions.

#Drive management:
    #Decided against removing UUID from /etc/fstab. 
    #also decided against removing /media/$(whoami)/parmanode directory for mounting.
    #unmounting is sufficient.

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
