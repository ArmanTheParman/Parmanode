function get_parmasql {

    [[ ! -e $dp/.parmasql_enabled ]] && {
    announce_blue "${cyan}Parmasql is a Database container with PostgreSQL, open-source relational
    database management system, with Parmanode menu commands to help you manage it.
    
    It is not enabled by default in Parmanode.

    It comes with all purchased fully-synced ParmanodL laptops and ParmaDrive machines 
    (16TB self-hosted cloud data + Parmanode Bitcoin Node).

    Contact Parman for more info, or see...
$green
    https://parmanode.com/parmanodl$blue"

    return 1
}

make_parmasql_ssh_keys && { 
announce_blue "ParmaSQL SSH keys made. Please contact Parman to enable.
$green

$HOME/.ssh/extra_keys/parmasql-key ...

$(cat ~/.ssh/extra_keys/parmasql-key.pub)$blue\n"  
return 1 
}

#If ParmaSQL is enabled and SSH keys are made, clone the repo and run the script

    if [[ ! -d $pp/parmasql ]] ; then
    git clone git@github-parmasql:armantheparman/parmasql.git $pp/parmasql || { sww "\n$blue    Something went wrong. Contact Parman.\n
    \r    Please contact Parman to enable ParmaSQL on your machine.\n$orange" ; return 1 ; }
    else
    cd $pp/parmasql && please_wait && git pull >$dn 2>&1
    fi

    source_premium
    install_parmasql
}