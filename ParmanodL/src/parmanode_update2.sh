function parmanode_update2 {
if [[ -e $HOME/parman_programs/parmanode ]] ; then
clear ; echo "
########################################################################################

    Parmanode will now update itself (Your installed programs won't be affected)

	<enter> to continue

########################################################################################
"
read && clear
cd $HOME/parman_programs/parmanode && git pull && cd - && clear
return 0
fi
return 1
}