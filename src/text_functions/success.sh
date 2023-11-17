function success {
set_terminal ; echo -e "
########################################################################################
$green                                  
                                  S U C C E S S  ! !
$orange
    $1 has finished $2

########################################################################################
"
enter_continue ; set_terminal ; return 0
}
