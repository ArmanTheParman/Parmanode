function set_dot_bitcoin_symlink {
set_terminal

#check there is a drive mounted, then make .bitcoin directory on external drive.
while true
do
echo "
########################################################################################

                             Preparing External Drive

    
    Please make sure your external drive is connected before proceeding. It needs 
    to be connected, and needs a few seconds to mount to:

                           /media/$(whoami)/parmanode/

    This should all work automoatically, but not everything can be anticipated. 

    OPTIONAL: 

    If you get an error, you can manually open a new terminal window (after 
    connecting the drive), and start by searching for the drive ID. Type:

                                    lsblk
                            or
                                    sudo lsblk
            
    You will get a readout of your drives. When you identify the right one, make a 
    note of its ID, eg: /dev/sdb or /dev/sdc etc. Then, making sure your current 
    directory is not the mount point, run this command:

                 sudo mount /dev/sdb /media/$(whoami)/parmanode/
            
    Make sure to use the correct drive ID. I have used sdb as an example. Once you do
    that, you can return to this program and retry.

########################################################################################
"
enter_continue
mount_drive
    if [ $? == 0 ] ; then
    break
    fi
done
# make a symlink on internal drive (.bitcoin should not exist there at this point)

    rm $HOME/.bitcoin /dev/null 2>&1 #removes symlink if it exists. Can't remove directory becuase no -r option.

    cd $HOME && ln -s /media/$(whoami)/parmanode/.bitcoin/ .bitcoin    #symlink can be made withouterrors even if target doesn't exist yet

set_terminal
echo "
########################################################################################

    A symlink (\"shortcut\") has been created pointing $HOME/.bitcoin, the default 
    Bitcoin Core data directory, to your external drive.

########################################################################################
"
enter_continue
return 0
}