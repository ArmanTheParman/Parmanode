function get_nodejs_and_npm {
if [[ -z $1 || -z $2 ]] ; then announce "get_nodejs_and_npm needs 2 numerical arguments. Aborting." ; return 1 ; fi

install_nodejs $1 || return 1
update_npm $2 || return 1
}