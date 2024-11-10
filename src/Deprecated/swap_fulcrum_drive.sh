#deprecated
function swap_fulcrum_drive {
# The docker version volume mounts to the external/internal drive at run
# command. To change it, it's more complicated, will do that later for Mac.
if [[ $OS == Mac ]] ; then no_mac ; return 0 ; fi

#check parmanode.conf variable setting.
source $pc

if [[ $drive_fulcrum == internal ]] ; then other="external" 
elif [[ $drive_fulcrum == external ]] ; then other="internal"
else announce "Unable to fetch drive status from parmanode.conf configuration file"
     return 1
fi

#from that, make confirmation window
while true ; do
set_terminal ; echo -en "
########################################################################################

    You are currently syncing Fulcrum data to the$cyan $drive_fulcrum drive$orange. Would you
    like to swap over to the$cyan $other drive$orange? 

$pink
    You will not lose data unless you instruct Parmanode to delete stuff.
    Also, no data is transferred form one drive to the other with this tool, it's 
    sipmly changing the syncing location.
$orange


                        s)       Swap to $other drive

                        a)       Nah, abort


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; a|A|N|n|no) return 0 ;; M|m) back2main ;; s) break ;; *) invalid ;; 
esac
done

#stop fulcrum
please_wait
stop_fulcrum

#check drive mounted
if [[ $other == external ]] ; then
if ! mount | grep -q parmanode ; then
announce "Please make sure the drive is mounted."
if ! mount | grep -q parmanode ; then
announce "Drive not mounted. Aborting."
return 1
fi 
fi
fi

#get space left on target drive
if [[ $other == external ]] ; then
space=$(df -h $parmanode_drive | awk '{print $4}' | tail -n1)
elif [[ $other == internal ]] ; then
space=$(df -h / | awk '{print $4}' | tail -n1)
fi

while true ; do
set_terminal ; echo -en "
########################################################################################

    Just FYI, you have$cyan $space$orange of space left on the$cyan $other$orange drive.

    Continue?

                                y)        Yes

                                n)        No

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|q) exit 0 ;; p|P) return 0 ;; n|N) return 0 ;; M|m) back2main ;; y) break ;; *) invalid ;;
esac
done

# Then check directory exists, then make if necessary 
if [[ $other == external && ! -e $pd/fulcrum_db ]] ; then
sudo mkdir $parmanode_drive/fulcrum_db
sudo chown -R $USER $parmanode_drive/fulcrum_db
fi

if [[ $other == internal && ! -e $HOME/.fulcrum_db ]] ; then
mkdir $HOME/.fulcrum_db
fi

#swap string for fulcrum.conf
if [[ $other == internal ]] ; then
gsed -i "/datadir =/c\datadir = $HOME/.fulcrum_db" $fc
elif [[ $other == external ]] ; then
gsed -i "/datadir =/c\datadir = $parmanode_drive/fulcrum_db" $fc
fi

#correct parmanode conf variable
parmanode_conf_remove "drive_fulcrum="
parmanode_conf_add "drive_fulcrum=$other"
success "The Fulcrum sync directory has been swapped over to the$cyan $other$orange drive.

    Start Fulcrum when you're ready."
}
