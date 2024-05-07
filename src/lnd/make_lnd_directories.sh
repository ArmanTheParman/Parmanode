function make_lnd_directories {
if [[ -d $HOME/.lnd ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    The .lnd directory exists on your computer. You have options:
$red
                       d)    Delete it and start fresh
$green
                       b)    Back it up to .lnd_backup
$orange
                       a)    Abort

########################################################################################
"
choose xpmq ; read choice ; set_terminal ; 
case $choice in
q|Q) exit ;; p|P|a|A) return 1 ;; 
d|D)
rm -rf $HOME/.lnd && mkdir $HOME/.lnd >/dev/null 2>&1
rm -rf $HOME/parmanode/lnd && mkdir $HOME/parmanode/lnd >/dev/null 2>&1
break
;;
b|B)
mv $HOME/.lnd $HOME/.lnd_backup 
mkdir $HOME/.lnd >/dev/null 2>&1
rm -rf $HOME/parmanode/lnd && mkdir $HOME/parmanode/lnd >/dev/null 2>&1
break
;;
*)
invalid
;;
esac 
done
}


