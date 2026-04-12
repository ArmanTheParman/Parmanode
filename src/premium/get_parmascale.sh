function get_parmascale {
if [[ ! -d $pp/parmascale ]] ; then
    git clone https://github.com/armantheparman/parmascale.git $pp/parmascale || { enter_continue "\n$blue    Something went wrong. Contact Parman.\n
    \r    Please contact Parman to enable ParmaScale on your machine.\n$orange" ; return 1 ; }
    installed_config_add "parmascale-end"
else
    cd $pp/parmascale && please_wait && git pull >$dn 2>&1
fi

source_premium
install_parmascale silent || return 1
}