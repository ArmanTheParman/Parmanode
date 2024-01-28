function menu_migrate {
while true ; do set_terminal ; echo -e "
########################################################################################
$cyan                            
                                Migrate Drive Menu            $orange                   

########################################################################################


      (parmy)    Migrate a drive from another Parmanode installation 

      (new)      Bring in new drive (will be formatted)

      (ub)       Migrate an Umbrel drive to Parmanode 

      (mn)       Migrate a MyNode drive to Parmanode 

      (rp)       Migrate a RaspiBlitz drive to Parmanode

      (eww)      Migrate a Parmanode drive back to Umbrel

      (rm)       Migrate a Parmanode drive back to MyNode

      (rr)       Migrate a Parmanode drive back to RaspiBlitz


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

parmy|Parmy|PARMY)

set_terminal ; echo -e "
########################################################################################
    Please$green connect$orange the Parmanode drive, wait a couple of seconds, then hit$green <enter>$orange
########################################################################################
"
enter_continue

if ! lsblk -o LABEL | grep -q parmanode ; then
set_terminal ; echo -e "
########################################################################################
    There does not seem to be a drive with a$cyan parmanode$orange Label connected. Aborting.
########################################################################################
"
enter_continue
return 1
fi

add_drive || { announce "Something went wrong. Aborting." ; return 1 ; }
success "The drive" "being imported"
offer_swap_to_external #runs only if drive=internal
;;

new)
format_ext_drive
offer_swap_to_external #runs only if drive=internal
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
