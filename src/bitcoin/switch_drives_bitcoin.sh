function switch_drives_bitcoin {

#make sure bitcoin has stopped.
stop_bitcoind
#bring in variables

#change symlinks as needed
if [[ $drive == "external" && $swap_to == "internal" ]] ; then

    if [ -L $HOME/.bitcoin ] ; then rm $HOME/.bitcoin ; fi

    set_terminal
    echo "

    The symbolic link pointing to the drive has been deleted. When you restart Bitcoin Core
    it will sync to the default internal directory ($HOME/.bitcoin).
    "
    parmanode_conf_remove "drive="
    parmanode_conf_add "drive=internal"

    enter_continue
    return 0
    fi

if [[ $drive == "internal" && $swap_to == "external" ]] ; then

while true ; do

    set_terminal
    echo "
########################################################################################

    If you have any bitcoin block data on the internal drive, it will be deleted. 
    Abort and back it up first if you don't want this to happen.

        p)                          Abort

        anything else)              Carry on

########################################################################################
"
read choice

case $choice in
q|Q|quit|QUIT|Quit)
exit ;;
p|P)
return 0 ;;
*)
break
;;
esac
done

#makeing a backup of bitcoin.conf
if [[ -f $HOME/.bitcoin/bitcoin.conf ]] ; then cp $HOME/.bitcoin $HOME/.parmanode/temp_bitcoin.conf ; fi

if [[ ! -L $HOME/.bitcoin ]] ; then
    sudo rm -rf $HOME/.bitcoin 
else
    set_terminal
    echo " $HOME.bitcoin seems to be a symlink. This is unexpected so parmanode will abandon proceedings."
    enter_continue
    return 1
fi

while true ; do set_terminal
echo "
########################################################################################

    New or existing drive?

        Parmanode can use an existing drive, but it needs to be configured first. This
        will label the drive, and register the UUID. If the data director is not
        in a .bitcoin directory at the root of the drive, you'll need to move it there
        yourself.

        Or, Parmanode can format and configure a new drive for you.


            e)    Use an existing drive

            n)    Use a new drive

########################################################################################
"
read choice

case $choice in
q|Q|quit|QUIT|Quit)
exit ;;
p|P)
return 0 ;;
e|E)
export use_existing_driv="true"
;;
n|N)
export use_new_drive="true"
;;
*)
invalid
;;
esac ; done

#update parmanode.conf
#both for linux and mac
#deal with pruning

}