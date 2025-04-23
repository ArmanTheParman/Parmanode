  function get_parmacloud {
  [[ ! -e $dp/.parmacloud_enabled ]] && announce_blue "$cyan

    With NextCloud, your machine can host your files like a Google Drive server,
    and you can access them from anywhere via your preferred domain name.    

    Contact Parman for set up. Fee is \$US400.$blue" && return 1 

make_parmacloud_ssh_keys && { announce_blue "ParmaCloud SSH keys made. Please contact Parman to enable." ; return 1 ; }

[[ ! -e $pp/parmacloud ]] && { 
    git clone git@github-parmacloud:armantheparman/parmacloud.git $pp/parmacloud || {
        enter_continue "Please contact Parman to enable ParmaCloud on your machine.\n$orange" ; return 1 ; 
    } #requires SSH key authority 
}
installed_conf_add "parmacloud-start"
for file in $pp/parmacloud/src/*.sh ; do source $file ; done
source_premium
install_parmacloud
}