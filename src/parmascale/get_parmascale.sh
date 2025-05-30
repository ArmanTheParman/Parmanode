function get_parmascale {
if [[ ! -e $dp/.parmascale_enabled ]] ; then 
announce_blue "ParmaScale is TailScale integration for all ParmaDrives, and part of$orange ParmaSwap$blue,
    where ParmaDrive machines owned by different people are connected, with automated
    receiprocal encrypted backups, to facilitate redundancy of your personal data, and 
    avoiding a single point of failure; this way you can deGoogle yourself safely.
$orange
    ParmaScale$blue is just one component of that. You man install Parmascale on your
    Parmanode machine (Mac or Linux) for a smol fee of only 40k sats."
else
make_parmascale_ssh_keys && { 
    announce_blue "ParmaScale SSH keys made. Please contact Parman to enable.
$green

$HOME/.ssh/extra_keys/parmascale-key ...

$(cat ~/.ssh/extra_keys/parmascale-key.pub)$blue\n" ; return 1 ; }
#If ParmaScale is enabled and SSH keys are made, clone the repo and run the script

    if [[ ! -d $pp/parmascale ]] ; then
    git clone git@github-parmascale:armantheparman/parmascale.git $pp/parmascale || { enter_continue "\n$blue    Something went wrong. Contact Parman.\n
    \r    Please contact Parman to enable ParmaScale on your machine.\n$orange" ; return 1 ; }
    installe_config_add "parmascale-end"
    else
    cd $pp/parmascale && please_wait && git pull >$dn 2>&1
    fi

source_premium
install_parmascale silent
fi
}