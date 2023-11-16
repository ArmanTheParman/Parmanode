function modify_prune {
#called from bitcoin menu
unset prune prune_value 

prune_before=$(cat $db/bitcoin.conf | grep prune= | cut -d = -f 2)
if [[ -z $prune_before ]] ; then prune_before=0 ; fi

prune_choice #extracts prune_value=number
debug "prune value is $prune_value ; before... $prune_before "
if [[ $prune_value == 0 && ( $prune_before -gt 0 ) ]] ; then

while true ; do
set_terminal ; echo -e "
########################################################################################

    You have chosen to$cyan abandon pruning$orange from the existing choice (ie.
    increasing the size of the stored data.)

    This might trigger a re-indexing of the chain and can take a very long time. 

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