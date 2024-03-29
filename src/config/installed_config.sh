function installed_config_add {
if [ ! -e $HOME/.parmanode/installed.conf ] ; then touch $HOME/.parmanode/installed.conf ; fi
program="$1"

installed_config_remove "$program" # ensures only single entry.

echo "$program" >> $HOME/.parmanode/installed.conf

return 0
}


function installed_config_remove {
if [ ! -e $HOME/.parmanode/installed.conf ] ; then return 0 ; fi

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

