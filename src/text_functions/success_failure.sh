function success {
if [[ -z $2 ]] ; then has_finished="" ; else has_finished="has finished" ; fi
set_terminal ; echo -e "
########################################################################################
$green                                  
                                  S U C C E S S  ! !
$orange
    $1 $has_finished $2

########################################################################################
"
enter_continue ; set_terminal ; return 0
}


function install_failure {
echo -e "
${red}Something went wrong.$orange Pausing so you can read the screen for any errors.
Hit$cyan <enter>$orange to continue."

set_terminal
echo -e "
########################################################################################
$red
                                F A I L U R E   :(
$orange
    Parmanode has detected that the $1 installation has failed. 

    To try again, you'd need to uninstall this partial installation from the 'remove'
    menu. 'Remove'is found in the main menu.

########################################################################################
"
enter_continue

}