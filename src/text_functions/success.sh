function success {
set_terminal ; echo "
########################################################################################
                                  
                                 S U C C E S S  ! !

    $1 has finished $2

########################################################################################
"
enter_continue ; set_terminal ; return 0
}
