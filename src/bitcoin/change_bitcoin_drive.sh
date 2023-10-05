function change_bitcoin_drive {
source $HOME/.parmanode/parmanode.conf
if [[ $drive == external ]] ; then otherdrive=internal ; fi
if [[ $drive == internal ]] ; then otherdrive=external ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                          CHANGE BITCOIN SYNCING DRIVE          
$orange
    You are currently syncing blocks to the $drive drive. 

    Would you like to change and sync data to the $otherdrive drive?


                            c)       change         (doesn't delete data)

                            n)       no, leave it    
 
########################################################################################
"
choose "xpq"
read choice ; set_terminal

case $choice in
q|Q) exit ;;
p|P|n|N|NO|No) return 1 ;;

c|C)
 #change systemctl? No - because symlink

  stop_bitcoind

if [[ $drive == external ]] ; then

    # No backup, just leave drive as is.
    rm $HOME/.bitcoin #deletes symlink to external drive
    parmanode_conf_remove "drive=" && parmanode_conf_add "drive=internal"

fi

if [[ $drive == internal ]] ; then
  if ! grep -q parmanode < /etc/fstab ; then

while true ; do
set_terminal ; echo -e "
########################################################################################

    It doesn't seem like you have imported a Parmanode drive. What would you like
    to do?

                  i)        Import an external drive

                  f)        Format a new drive 

                  a)        Abort, Abort!

########################################################################################
"
choose "xpq"
read choice ; set_terminal
case $choice in
q|Q) exit ;;
a|A|p|P|n|N|NO|No) return 1 ;;
i|I)
add_drive
if ! grep -q parmanode < /etc/fstab
continue 
fi
return 0
;;
f|F)
format_ext_drive justFormat
return 0
;;
*)
invalid ;;
esac
done

fi #ends if no parmanode in fstab


    make_backup_dot_bitcoin
    cd $HOME && ln -s /media/$(whoami)/parmanode/.bitcoin/ .bitcoin
    parmanode_conf_remove "drive=" && parmanode_conf_add "drive=external"

fi  #ends if $drive=internal

    start_bitcoind
    return 0

;; #finished swapping internal/external 

*)
invalid ;;
esac
done
}