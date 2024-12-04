function menu_migrate {
unset check_if_parmanode_drive newmigrate justFormat importdrive bitcoin_drive_import
while true ; do 
if [[ -z $1 ]] ; then # if an option passed, then no need to print menu
set_terminal ; echo -e "
########################################################################################
$cyan                            
                                Migrate Drive Menu            $orange                   

########################################################################################

$cyan
      (parmy)$orange    Import a Parmanode drive to use with Parmanode 
$cyan
      (new)$orange      Make a new external Parmanode drive (will be formatted)
$cyan
      (ub)$orange       Migrate an Umbrel drive to Parmanode 
$cyan
      (mn)$orange       Migrate a MyNode drive to Parmanode 
$cyan
      (rp)$orange       Migrate a RaspiBlitz drive to Parmanode
$red
      (eww)$orange      Migrate a Parmanode drive back to Umbrel
$cyan
      (rm)$orange       Migrate a Parmanode drive back to MyNode
$cyan
      (rr)$orange       Migrate a Parmanode drive back to RaspiBlitz


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
add_drive || { announce "Something went wrong. Aborting." ; return 1 ; }
success "The drive" "being imported"
offer_swap_to_external #runs only if drive=internal
return 0
;;

new)
export newmigrate="true"
export justFormat="true"
export drive=external && parmanode_conf_add "drive=external"
format_ext_drive Bitcoin
stop_bitcoin
prune_choice || return 1 
make_bitcoin_directories
make_bitcoin_conf || return 1
sudo chown -R $USER: $HOME/.bitcoin/ 
set_rpc_authentication "s" "install"
please_wait && start_bitcoin
unset newmigrate drive
success "The new drive" "being imported"
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
