function success {
if [[ -z $2 ]] ; then has_finished="" ; else has_finished="has finished" 
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
