function menu_migrate {
unset check_if_parmanode_drive newmigrate justFormat importdrive bitcoin_drive_import
while true ; do 
if [[ -z $1 ]] ; then # if an option passed, then no need to print menu
set_terminal ; echo -e "
########################################################################################
$cyan                            
                                Menu Migrar drive            $orange                   

########################################################################################

$cyan
      (parmy)$orange    Importar uma drive Parmanode para utilizar com o Parmanode 
$cyan
      (new)$orange      Criar uma nova drive Parmanode externa (será formatada)
$cyan
      (ub)$orange       Migrar uma drive Umbrel para a Parmanode
$cyan
      (mn)$orange       Migrar uma drive MyNode para a Parmanode 
$cyan
      (rp)$orange       Migrar uma drive RaspiBlitz para o Parmanode
$red
      (eww)$orange      Migrar uma drive Parmanode de volta para a Umbrel
$cyan
      (rm)$orange       Migrar uma drive Parmanode de volta para o MyNode
$cyan
      (rr)$orange       Migrar uma drive Parmanode de volta para o RaspiBlitz


########################################################################################
"
choose "xpmq"
read migratechoice
jump $migratechoice || { invalid ; continue ; } ; set_terminal
else
migratechoice="$1"
set_terminal
fi

case $migratechoice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;;

parmy|Parmy|PARMY)
export check_if_parmanode_drive="true" # read by detect_drive (which is called by add_drive)
add_drive || { announce "Algo correu mal. Abortar." ; return 1 ; }
success "A drive" " a ser importada"
offer_swap_to_external #runs only if drive=internal
return 0
;;

new)
export newmigrate="true"
export justFormat="true"
export drive=external && parmanode_conf_add "drive=external"
format_ext_drive
stop_bitcoin
prune_choice || return 1 
make_bitcoin_directories
make_bitcoin_conf || return 1
sudo chown -R $USER: $HOME/.bitcoin/ 
set_rpc_authentication "s" "instalar"
please_wait && start_bitcoin
unset newmigrate drive
success "A nova drive" " a ser importada"
return 0
;;

ub|UB|Ub)
umbrel_import 
offer_swap_to_external
;;

mn|MN|Mn)
mynode_import
offer_swap_to_external
;;

rp|RP|Rp)
raspiblitz_import
offer_swap_to_external
;;

eww|Eww|EWW)
umbrel_revert
;;

rm|RM|Rm)
mynode_revert
;;

RR|rr|Rr)
raspiblitz_revert
;;

*)
invalid
;;

esac
done
}
