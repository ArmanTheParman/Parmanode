function import_bitcoin_install {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               IMPORT BITCOIN TOOL

$orange
    If you already have Bitcoin installed on your system, you can simply bring it
    in so Parmanode can recognise it.

########################################################################################
"
choose "epmq"
read choice ; clear
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;; "") break ;; *) invalid ;;
esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode will stop bitcoin running with the command:
   $green 
        bitcoin-cli stop
       $orange 

    Hit$pink <enter>$orange to continue (it dosn't matter if bitcoin is not actually 
    running right now).

########################################################################################
"
choose "epmq"
read choice ; clear
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;; "") break ;; *) invalid ;;
esac
done

if [[ ! -f /usr/local/bin/bitcoind && ! -f /usr/local/bin/bitcoin-cli ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has not detected bitcoind and bitcoin-cli in the expected directory:
$green
        /usr/local/bin
$orange
    Please open a new terminal window and move those binary files (and others like
    bitcoin-qt and bitcoin-tx if you have them) to the above direcotry.

    I'll wait.

    Then hit$pink <enter>$orange to continue.

########################################################################################
"
choose "epmq"
read choice ; clear
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;; "") break ;; *) invalid ;;
esac
done
else

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected Bitcoin binary files in$green /usr/local/bin$orange

    If these are not the files you are intending to use, then open a new terminal and
    move your target binaries to this location. You need the files:
$green
        bitcoind  $orange
        & $green
        bitcoin-cli
   $orange 
    in the directory /usr/local/bin

    Once that is done, hit$pink <enter>$orange to continue the wizard.

########################################################################################
"
choose "epmq"
read choice ; clear
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;; "") break ;; *) invalid ;;
esac
done
fi


unset drive
while true ; do
set_terminal ; echo -e "
########################################################################################

    Now we need to decide about the Bitcoin block data location.

    Do you want...

        1)    Start fresh with an external drive$red (formats drive)

        2)    Start fresh with an internal drive

        3)    Use your existing data from an external drive

        4)    Use your existing data from an internal drive

        5)    Use your existing data from a Parmanode external drive

########################################################################################
"
choose "xpmq"
read choice ; clear
case $choice in
1)
# Some variables to control how functions branch, esp install_bitcoin and children.
export drive=external  && parmanode_conf_add "drive=external"
export justFormat=true
export version=self
install_bitcoin || return 1
#format_ext_drive "Bitcoin" #is the drive mounted here?
#prune_choice || return 1
#make_bitcoin_directories
#make_bitcoin_conf
#make_mount_check_script
#make_bitcoind_service_file
;;

2)
export drive=internal && parmanode_conf_add "drive=internal"
export version=self
install_bitcoin || return 1
;;

3)
export version=self
export drive=external 
parmanode_conf_add "drive=external"
export bitcoin_drive_import=true #borrowed variable, can't use importdrive (variable gets unset)
export skip_fomratting=true
add_drive || return 1 # imports drive and makes directories if they don't exist.
#need to find the bitcoin directory
dir_not_found #?
#need to decide about bitcoin conf
replace_bitcoin_conf || return 1
message_move #move files before continuing

#functions needed from install_bitcoin:
#make_mount_check_script
#make_bitcoind_service_file
#set_rpc_authentication (if rpcuser not set)
install_bitcoin
;;

4)
export version=self
export drive=internal ;
parmanode_conf_add "drive=internal"
export bitcoin_drive_import=true 
#need to decide about bitcoin conf
replace_bitcoin_conf || return 1
message_move #move files before continuing

#functions needed from install_bitcoin:
#make_mount_check_script
#make_bitcoind_service_file
#set_rpc_authentication (if rpcuser not set)
install_bitcoin
;;
########################################################################################
########################################################################################
# UP TO HERE...
########################################################################################
########################################################################################
5)
export version=self
export drive=external 
parmanode_conf_add "drive=external"
export bitcoin_drive_import=true 
menu_migrate parmy || return 1 # drive is detected, fstab added, directories made if non existant.
#need to find the bitcoin directory
dir_not_found #?

#functions needed from install_bitcoin:
#make_mount_check_script
#make_bitcoind_service_file
#set_rpc_authentication (if rpcuser not set)
install_bitcoin
;;
*)
invlalid ;;
esac
done
}


function dir_not_found {

if [[ $drive == external ]] ; then ############### for tracking nested if... can't indent because echo statements
default="$parmanode_drive/.bitcoin"

if ! grep -q "electrs" <$dp/.temp ; then
text1="
    ${cyan}The same is true for $paranode_drive/electrs_db$orange"
fi

if ! grep -q "fulcrum" <$dp/.temp ; then
text2="
    ${cyan}The same is true for $paranode_drive/fulcrum_db$orange"
fi

elif [[ $drive == internal ]] ; then ###############
default="$HOME/.bitcoin"
else ###############
announce "an error has occured. No drive variable found. Caution. Control-c
    to quit."
return 1
fi ###############



if ! grep -q "bitcoin" < $dp/.temp ; then #this means mkdir didn't fail, and .bitcoin dir didn't exist initially

set_terminal ; echo -e "
########################################################################################

    Parmanode didn't detect a Bitcoin data directory in its default location:
$cyan
        $default
$orange
    Notice the '.' which means it's a hidden directory. Parmanode has created this
    directory for you but it is empty. If you want Parmanode to sync Bitcoin data
    on top of the data you already have, then WHILE BITCOIN IS STOPPED, copy your
    existing data to the above location, then start bitcoin from the Parmanode
    Bitcoin menu.
    $text1
    $text2
########################################################################################
"
enter_continue
fi
}

function replace_bitcoin_conf {
#expecting only to be called if export_bitcoin_drive=true

while true ; do
set_terminal ; echo -e "
########################################################################################

    It is recommended that you use the Parmanode bitcoin.conf file, but you can
    decline and use your own, just make sure it lives in the .bitcoin data directory
    before you start bitcoin.

    You have choices...
$green
            1)    Use Parmanode's bitcoin.conf (recommended)
$orange 
            2)    Use your own shitty bitcoin.conf file, see if I care

########################################################################################
"
choose "xpmq" ; read choice ; clear
case $choice in
1)
#turn off switch and back on
unset bitcoin_drive_import && prune_choice && export bitcoin_drive_import=true
#turn off switch and back on
unset bitcoin_drive_import && make_bitcoin_conf && export bitcoin_drive_import=true
;;
2)
break
;;
*)
invalid
;;
esac
done
}

function message_move {
set_terminal ; echo -e "
########################################################################################
    
    If your own Bitcoin data needs to be moved to the target directory on the drive
    please, make sure you have done that before proceeding. Just leave this window
    open, open a new one and do the work needed, then come back and continue.

########################################################################################
"
enter_continue
}