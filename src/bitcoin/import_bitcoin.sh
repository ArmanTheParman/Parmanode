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
export importbitcoindrive=external_new 
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
importbitcoindrive=internal_new 
export drive=internal && parmanode_conf_add "drive=internal"
export version=self
install_bitcoin || return 1
;;
########################################################################################
########################################################################################
# UP TO HERE...
########################################################################################
########################################################################################
3)
export version=self
importbitcoindrive=external_existing 
export drive=external 
parmanode_conf_add "drive=external"
export bitcoin_drive_import=true #borrowed variable, can't use importdrive (variable gets unset)
export skip_fomratting=true
#need to decide about bitcoin conf
#need to find the bitcoin directory

#functions needed from install_bitcoin:
make_mount_check_script
make_bitcoind_service_file

;;
4)
importbitcoindrive=internal_existing 
export drive=internal ;
parmanode_conf_add "drive=internal"
;;
5)
importbitcoindrive=external_parmanode 
export drive=external 
parmanode_conf_add "drive=external"
;;
*)
invlalid ;;
esac
done

export import_bitcoin=true #delete everywhere if not needed.
export version=self
    #when running install_bitcoin...
    #skips choose_bitcoin_version
    #skips choose_and_prepare_drive
    #skips format_ext_drive - do this in case 1 above
    #skips download_bitcoin, because version=self

install_bitcoin

