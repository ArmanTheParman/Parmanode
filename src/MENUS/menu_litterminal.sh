function menu_litterminal {

get_onion_address_variable litterminal

set_terminal ; echo -e "
########################################################################################$cyan
                               Menu Lightning Terminal     $orange 
########################################################################################



    O Lightning Terminal pode ser acedido no seu browser em:


                           https://localhost:${green}8443$orange


                           https://$IP:${yellow}8033$orange

                                      $bright_blue
    https://$ONION_ADDR_LITTERMINAL:7007                            $orange
 


########################################################################################
"
enter_continue ; jump $enter_cont
}
