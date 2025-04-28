function update_parmanode {

if [[ $version_incompatibility == 1 ]] ; then #this variable is set in update_version_info 

    if ! curl https://google.com >$dn 2>&1 ; then
    announce "It seems the internet might be disconnected. Proceed with caution."
    return 0
    fi

# function. If 1, then the current version can't be updated.
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected a problem - two possibilites.
   $cyan 
    1)$orange You may have a very old version of Parmanode that is not backwards compatible 
    with the latest version. To get the new version, you should uninstall Parmanode.
    You would also need to uninstall all the apps Parmanode installed for you to 
    be sure of no conflicts. Alternatively, continue to use this current version.
$cyan
    2)$orange If your version is not that old (> version 3), then it's possilbe there's 
    some glitch in the code - it's probably my fault. Please contact me by Telegram
    or email or Twitter to report.

########################################################################################
"
enter_continue
return 1 
fi

if [[ ! -f $pn/version.conf ]] ; then # this file was introduced in newer versions
# of parmanode
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that you are probably using a version$red v3.2.0$orange or earlier.
    
    If you are using any version starting with 1 or 2 (3.x.x is ok), then the latest 
    version won't be compatible with your computer the way things are now. You 
    shouldn't install it or there will conflicts. You need to first uninstall the old 
    version before downloading the new. Apologies for not forseeing this issue and 
    preventing it.

    If the detection is mistaken, there's probably some glitch. Please contact me by
    Telegram or email or Twitter to report.

########################################################################################
"
enter_continue ; return 1 
fi

# above checks done without exiting, update can proceed.

if [[ $1 == refresh ]] ; then
parmanode_refresh
return 0
fi

cd $pn
git config pull.rebase false >$dn 2>&1
if git pull | grep "Already up" ; then enter_continue ; return 1 ; fi
# grep searches for a string that occurs only when there are no updates required.
# otherwise, some update has happened...
success "Parmanode" "being updated"
export exit_loop="false"
return 0 
}
