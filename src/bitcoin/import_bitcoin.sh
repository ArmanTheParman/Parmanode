function import_bitcoin {
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

while true ; do
set_terminal ; echo -e "
########################################################################################

    Now we need to decide about the Bitcoin block data location.

    Do you want...

        1)    Start fresh with an external drive

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
export importbitcoindrive=external_new ;;
2)
importbitcoindrive=internal_new ;;
3)
importbitcoindrive=external_existing ;;
4)
importbitcoindrive=internal_existing ;;
5)
importbitcoindrive=external_parmanode ;;
*)
invlalid ;;
esac
done

