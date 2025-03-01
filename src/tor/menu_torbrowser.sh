function menu_torbrowser {
if ! grep -q "torb-end" $ic ; then return 0 ; fi
if [[ $OS == "Mac" ]] ; then
text="$cyan       Mac:             ${orange}Run fromt the Mac OS Applications folder.
"
else
text="$cyan       start)    ${orange}start command here won't always work, because Tor 
                        Browser moves things around without permission. You can
                        alternatively use the start menu, you might find the Tor icon 
                        there. Another way it to find the run script here: $green

                        $hp/tor-browser/ $orange directory. 
"
fi

set_terminal ; echo -e "
########################################################################################

                     $cyan              TOR Browser    $orange


       $text
######################################################################################## 
"
enter_continue ; jump $enter_cont 
debug "enter_cont: $enter_cont"
case $enter_cont in  start) nohup $hp/tor-browser/Browser/start-tor-browser & ;; 
esac
return 0
}
