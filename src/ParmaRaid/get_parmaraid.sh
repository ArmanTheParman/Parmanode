function get_parmaraid {
[[ ! -e $dp/.parmaraid_enabled ]] && parmaraid_info && return 1 

make_parmaraid_ssh_keys && { announce_blue "ParmaRaid SSH keys made" ; return 1 ; }

git clone git@github-parmaraid:armantheparman/parmaraid.git $pp/parmaraid 2>$dn ||
{ cd $pp/parmaraid 2>$dn && git pull >$dn 2>&1 ; } ||
{ enter_continue "Please contact Parman to enable ParmaRaid on your machine.\n$orange" ; return 1 ; } #requires SSH key authority

for file in $pp/parmaraid/src/*.sh ; do
source $file
done

install_raid
return 0
}