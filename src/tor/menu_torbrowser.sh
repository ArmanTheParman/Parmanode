function menu_torbrowser {
set_terminal ; echo -e "
########################################################################################

                     $cyan              TOR Browser    $orange

    To use Tor Browser
$cyan
       Linux: $orange   Use the start menu, you'll find the Tor icon there. 
$cyan    
       Mac:$orange      Run fromt the Mac OS Applications folder. 

######################################################################################## 
"
enter_continue ; jump $enter_cont 
return 0
}
