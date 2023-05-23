function error_BC100 {

echo "
########################################################################################

    ERROR BC100 - bitcoin.conf file creation failed (already exists)

########################################################################################

Aborting. Hit <enter>
"

enter_continue
return 0
}


function error_CF100 {
clear
echo "
########################################################################################    

                                    Error CF100

    Make sure Parmanode has been installed first (go to Add more programs menu).
    
    Or, Parmanode may need to be re-installed cleanly after uninstalling.

########################################################################################    
"
enter_continue
return 0

}


function error_i100 {

set_terminal
echo "
########################################################################################

                            Error i100 - Install Error 

########################################################################################

Hit <enter> to abort.
"
read
return 0
}

function errormessage {
echo ""
echo "There has been an error. See log files for more info."
enter_continue
}

