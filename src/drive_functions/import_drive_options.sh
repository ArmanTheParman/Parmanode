function import_drive_options {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please chosse the type of external drive you wish to use for Parmanode:


                      pp)  Parmanode drive from another installation

                      u)   Umbrel drive

                      rb)  RaspiBlitz drive

                      my)  MyNode drive

########################################################################################                
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit ;; q|P) return 1 ;;
m|M) back2main ;;
pp|Pp|PP)
export importdrive=true
add_drive 
if [[ $OS == "Linux" ]] ; then
        # The following function is redundant, but added in case the dd function (which
        # calls this function earlier is discarded). 
        remove_parmanode_fstab

        #Extract the *NEW* UUID of the disk and write to config file.
        get_UUID "$disk" 
        parmanode_conf_add "UUID=$UUID"
        write_to_fstab "$UUID"
fi
;;



}