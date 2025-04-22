function success_blue {
if [[ $preconfigure_parmadrive == "true" ]] ; then return 0 ; fi
bluesuccesscolour="true"
success "$@"
}


function success {
debug "pre-success menu"
if [[ $preconfigure_parmadrive == "true" ]] ; then return 0 ; fi
if [[ $bluesuccesscolour == "true" ]] ; then temp=$orange ; orange=$blue ; fi

if [[ -z $2 ]] ; then has_finished="" ; else has_finished="has finished" ; fi
set_terminal ; echo -e "$orange
########################################################################################
$green                                  
                                  S U C C E S S  ! !
$orange
    $1 $has_finished $2

########################################################################################
$orange"
if [[ $bluesuccesscolour == "true" ]] ; then orange=$temp ; unset temp; fi
enter_continue ; set_terminal ; unset blueseccesscolour ; return 0
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
    menu. 'Remove' is found in the main menu.

########################################################################################
"
enter_continue

}