function menu_torbrowser {
if ! grep -q "torb-end" $ic ; then return 0 ; fi
set_terminal ; echo -e "
########################################################################################

                     $cyan              TOR Browser    $orange

    To use Tor Browser
$cyan
       Linux:           ${orange}Use the start menu, you'll find the Tor icon there. On
                        some Linux distributions, it won't be there. In that case,
                        run it from the$cyan

                        $hp/tor-browser/ $orange directory. 
$cyan    

       Mac:$orange      Run fromt the Mac OS Applications folder. 

######################################################################################## 
"
enter_continue ; jump $enter_cont 
return 0
}
