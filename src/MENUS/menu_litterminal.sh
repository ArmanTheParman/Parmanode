function menu_litterminal {

get_onion_address_variable litterminal

while true ; do set_terminal ; echo -e "
########################################################################################$cyan
                               Lightning Terminal Menu     $orange 
########################################################################################

      The Lightning Terminal can be accessed in your browser at:


                           https://localhost:${green}8443

                               or

                           https://$IP:${yellow}8033

                              or $bright_blue

    https://$ONION_ADDR_LITTERMINAL:7007                            


########################################################################################
"
enter_continue
}