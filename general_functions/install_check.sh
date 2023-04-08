
function install_check { 
program_name=$1

    if grep -q "$1" $HOME/.parmanode/installed.conf 2>/dev/null

    then 
        install_error "$program_name"
        previous_menu
        return 1 

    else 
        return 0

    fi

}

function install_error {
program_name=$1
if [[ $program_name == "parmanode" ]] ; then

echo "
########################################################################################
	
                                    Install Error

            Parmanode cannot be re-installed unless fully uninstalled 
      	    first (there may be remnants which an proper uninstall will
            clearn up).

            If you're trying to add Bitcoin, or another program, go via
            the \"Add more programs\" menu.

########################################################################################
"
return 0

else
echo "

########################################################################################
                                    
                                    Install Error

    Previous installation detected. Please cleanly uninstall before trying again. 

    This is precaution to reduce the chance of errors.

########################################################################################
"
return 0
fi
}

