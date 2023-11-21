function update_parmanode {

if [[ $version_incompatibility == 1 ]] ; then #this variable is set in update_version_info 
# function. If 1, then the current version can't be updated.
set_terminal ; echo "
########################################################################################

    Parmanode has detected that your version of Parmanode is not backwards compatible
    with the latest version. To get the new version, you should uninstall Parmanode.
    You would also need to uninstall all the apps Parmanode installed for you to 
    be sure of no conflicts. Alternatively, continue to use this current version.

########################################################################################
"
enter_continue
return 1 
fi

if [[ ! -f $original_dir/version.conf ]] ; then # this file was introduced in newer versions
# of parmanode
set_terminal ; echo "
########################################################################################

    Parmanode has detected that you are probably using a version v3.2.0 or earlier.
    
    If you are using any version starting with 1 or 2 (3.x.x is ok), then the latest 
    version won't be compatible with your computer the way things are now. You 
    shouldn't install it or there will conflicts. You need to first uninstall the old 
    version before downloading the new. Apologies for not forseeing this issue and 
    preventing it.

########################################################################################
"
enter_continue ; return 1 
fi

# above checks done without exiting, update can proceed.
while true ; do
if [[ $1 != dontask ]] ; then
set_terminal ; echo -e "
########################################################################################

                      $cyan           Update Parmanode  $orange
    
    Parmanode will update itself by extracting the latest version from GitHub.com

    Proceed?  (y) or (n)

########################################################################################
"
choose "xpmq" ; read choice
else
choice=y
fi

case $choice in q|Q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;;
M|m) return 0 ;;
n|N|No|NO|no) return 1 ;;
y|Y|Yes|YES|yes)
cd $original_dir
git config pull.rebase false >/dev/null 2>&1
if git pull | grep "Already up" ; then enter_continue ; return 1 ; fi
# grep searches for a string that occurs only when there are no updates required.
# otherwise, some update has happened...
debug2 "updated parmanode success, exit loop made false"
success "Parmanode" "being updated"
export exit_loop=false
return 0 
;;

*)
invalid ;;
esac
done

}
