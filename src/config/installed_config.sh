function installed_config_add {
if [ ! -e $ic ] ; then touch $ic ; fi
program="$1"

installed_config_remove "$program" # ensures only single entry.

echo "$program" | tee -a $ic 

return 0
}


function installed_config_remove {
if [ ! -e $ic ] ; then return 0 ; fi

delete_line "$HOME/.parmanode/installed.conf" "${1}"

return 0
}

function installed_conf_remove {
installed_config_remove "$1"
}
function installed_conf_add {
installed_config_add "$1"
}
function install_conf_remove {
installed_config_remove "$1"
}
function install_conf_add {
installed_config_add "$1"
}
function install_config_remove {
installed_config_remove "$1"
}
function install_config_add {
installed_config_add "$1"
}

