function installed_config_add {

program="$1"
installed_config_remove "$program" # ensures only single entry.

echo "$program" >> $HOME/.parmanode/installed.conf

return 0
}


function installed_config_remove {
program="$1"

delete_line "$HOME/.parmanode/installed.conf" "$program"

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

