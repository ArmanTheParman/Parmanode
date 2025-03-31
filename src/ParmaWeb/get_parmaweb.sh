function get_parmaweb {
[[ ! -e $dp/.parmaweb_enabled ]] && announce_blue "${cyan}With Parmaweb, you can host your own WordPress Server (Linux Only)
    with a database configured, help with reverse proxying if you need it
    and free domain name (or buy your own)$orange yourchoice.parmacloud.com$blue
    
    Contact Parman for setup. Fee is \$500 USD." && return 1 

[[ -z $another ]] && make_parmaweb_ssh_keys && { announce_blue "ParmaWeb SSH keys made" ; return 1 ; }

git clone git@github-parmaweb:armantheparman/parmaweb.git $pp/parmaweb 2>$dn || {
cd $pp/parmaweb && git pull >$dn 2>&1 ; } || \
{ enter_continue "Please contact Parman to enable ParmaWeb on your machine.\n$orange" ; return 1 ; } #requires SSH key authority

for file in $pp/parmaweb/src/*.sh ; do
source $file
done

install_website
return 0
}