# Argument 1 passes program name. If already installed, then error processing.
# If argument $2 is "i==0" then calling function wants opposite behaviour.
# Default is $2 is "i==1"

function install_check { 
log "install_check" "arg 1 is $1, arg 2 is $2"
program_name=$1
log "install_check" "arg 1 is $1, arg 2 is $2"
arg2=$2
log "install_check" "arg 1 is $1, arg 2 is $2"

    if grep -q "$program_name" $HOME/.parmanode/installed.conf 2>/dev/null

    then 
        if [[ $arg2 == "i=0" || $arg2 == "i==0" ]] ; then return 0 ; fi
        log "$program_name" "Install error. Already installed"
        install_error "$program_name"
        previous_menu
        return 1 

    else 
        if [[ $arg2 == "i=0" || $arg2 == "i==0" ]] ; then return 1 ; fi
        log "$program_name" "arg2 is $arg2"
        log "$program_name" "Install check passed; not installed. Continuing."
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

