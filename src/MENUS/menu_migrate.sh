function menu_migrate {
while true ; do set_terminal ; echo -e "
########################################################################################
$cyan                            
                                Migrate Drive Menu            $orange                   

########################################################################################


      (parmy)    Migrate a drive from another Parmanode installation 

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
#add_drive || return 1
#detect_if_parmanode_drive
#success "The drive" "being imported"
remove_parmanode_fstab

get_UUID || return 1 # checks 1 and only one parmanode drive is connected and gets UUID variable, or return 1
                 
offer_swap_to_external #runs only if drive=internal
unset disk
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

function detect_if_parmanode_drive {

if ! lsblk -o LABEL $disk | grep -q parmanode >/dev/null 
then
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that the drive you are importing is not already a 
    Parmanode drive.

    Would you like to ...

            new)   Set it up as a new Parmanode drive (will FORMAT)

            keep)  Keep the data, label the drive as Parmanode, and manually
                   make 



}