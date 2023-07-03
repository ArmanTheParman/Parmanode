function greadlink_check {

if ! command -v greadlink ; then 
get_greadlink
if [ $? == 0 ] ; then installed_conf_add "greadlink" ; fi
else
installed_conf_add "greadlink"
fi

}


function get_greadlink {

info_greadlink
brew install coreutils
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

