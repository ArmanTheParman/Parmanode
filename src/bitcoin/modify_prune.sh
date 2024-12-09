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

    Optou por$cyan abandonar a prune $orange da escolha existente (ie.
    aumentar o tamanho dos dados armazenados.)

    Isto pode desencadear uma re-indexação da cadeia e pode demorar muito tempo.

$green                  c)     Continuar

$red                  a)     Abortar
$orange
########################################################################################
"
choose "xpqm" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; a|A|p|P) return 1 ;; m|M) back2main ;; c|C) break ;; *) invalid ;;
esac
done
fi

stop_bitcoin
apply_prune_bitcoin_conf
set_terminal ; echo -e "
########################################################################################

   Solicitação de valor da prune concluída. Por favor, inicie o Bitcoin manualmente 
   a partir do menu Parmanode Bitcoin quando estiver pronto.

########################################################################################
"
enter_continue ; jump $enter_cont
return 0
}
