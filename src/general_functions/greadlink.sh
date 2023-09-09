function greadlink_check {

if ! command -v greadlink ; then #checks if the command doesn't exist (! is "not")
get_greadlink
if [ $? == 0 ] ; then installed_conf_add "greadlink" ; fi #adds to config if command above doesn't return an error
else
installed_conf_add "greadlink" # if the command exists, it's noted in the config file.
fi
}


function get_greadlink {

info_greadlink
brew install coreutils # greadlink is part of coreutils package.
}

function info_greadlink {
set_terminal ; echo "
########################################################################################

                             Because you use Mac

    Parmanode needs a link reading function in the background which isn't available
    Mac by default. Parmanode will now install this program which comes as a
    package called \"core utils\". Sit back, it'll take 2 to 10 minutes ...

########################################################################################
"
enter_continue 
}

