function modify_prune {
#called from bitcoin menu
unset prune

prune_before=$(cat $db/bitcoin.conf | grep prune= | cut -d = -f 2)
if [[ -z $prune_before ]] ; then prune_before=0 ; fi

prune_choice #extracts prune_value=number

if [[ $prune_choice != 0 && $prune_before -lt $prune_choice ]] || \ 
[[ $prune_choice == 0 && $prune_before -gt 0 ]] ; then

while true ; do
set_terminal ; echo -e "
########################################################################################

    You have chosen to reduce pruning from the existing choice. 
    This will trigger a re-indexing of the chain and can take a very long time. 

$green                  c)     Continue

$red                  a)     Abort
$orange
########################################################################################
"
choose "xpqm" ; read choice
case $choice in
q|Q) exit ;; a|A|p|P) return 1 ;;
m|M) back2main ;;
c|C) break ;;
*) invalid ;;
esac
done
fi

stop_bitcoind
apply_prune_bitcoin_conf
set_terminal ; echo -e "
########################################################################################

   Prune value request complete. Please start Bitcoin manually from the Parmanode
   Bitcoin menu when ready.

########################################################################################
"
enter_continue
return 0
}