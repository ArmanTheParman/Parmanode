function config_warning {
# argument 1 should be the program name
while true ; do
clear
echo -e "
########################################################################################
    
    Please$pink be aware$orange, if you have, or will, install $1 separate 
    to the Parmanode installation, both editions will use the same configuration
    directory.

    If you or Parmanode deletes the configuration directory during uninstalling, it
    will affect the other.$green Parmanode will ask you first before deleting.$orange

########################################################################################
"
enter_abort 
read choice ; case $choice in a|A) return 1 ;; "") return 0 ;; esac ; done
}