function check_if_win7 {
# will return win7+, linux, or not_win string.
if [[ $(uname -s) == MINGW* ]] ; then
    version=$(wmic os get version | grep -oE "[0-9]+.[0-9]+")
    if (( $(echo "$version >= 6.1" | bc -l) )) ; then
        export OS="Win"
    else
        export OS="Win_old"
    fi
else
    export OS="Not_Win"
fi
return 0
}


function check_architecture {
if [[ $(uname) == Linux ]] ; then

    architecture=$(lscpu | grep Architecture | awk '{print $2}')
    parmanode_conf_add "architecture=$architecture"

    if [[   $architecture == armv6l || \
            $architecture == armv7l || \
            $architecture == i386   || \
            $architecture == i486   || \
            $architecture == i586   || \
            $architecture == i686   ]] ; then #32 bit machine

        if ! lscpu | grep "CPU op-mode" | grep -q "64" ; then 

            announce "This seems to be a 32-bit machine. Parmanode and some apps you
            \r    install may not work properly, even if they install successfully.
            \r    Please run Parmanode on on a 64-bit machine. Be warned." 
        fi
    fi

fi
}

function test_8333_reachable {
pn_tmux "nc -z -w 5 $external_IP 8333 || { gsed -i '/_8333reachable/d' $pc ; exit 1 ; }
         gsed -i '/_8333reachable.*$/d' $pc
         echo '_8333reachable=true' >> $pc" "check_port_8333"
}