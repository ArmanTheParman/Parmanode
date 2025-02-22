function which_os {
# This function just extracts and stores the operating system name

if [[ $(uname) == "Darwin" ]] #uname gives useful info about the system.
then
    export OS="Mac"
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >$dn ; fi
    # This is adding the variable to a configuration file.
    # Parmanode_conf_add takes an argument (the text after it is called) and adds that to 
    # The parmanode.conf file
    # I later realised this is unnecessary if I just "export" the variable, making it always available
    # I'll clean up the code later.
    return 0 
fi

if [[ $(uname) == "Linux" ]]
then
    export OS="Linux"
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >$dn ; fi
    return 0
fi

if [[ "$(uname)" == "MINGW32_NT" || "$(uname -s)" == "MINGW64_NT" ]] 
then
    check_if_win7
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >$dn ; fi
    exit 1
fi
echo "unknown OS, exiting." ; sleep 3

}