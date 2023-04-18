function which_os {

chip=$(uname -m)
if [[ "$(uname -s)" == "Darwin" ]]
then
    OS="Mac"
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >/dev/null ; fi
    return 0 
fi

if [[ "$(uname -s)" == "Linux" ]]
then
    OS="Linux"
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >/dev/null ; fi
    return 0
fi

if [[ "$(uname -s)" == "MINGW32_NT" || "$(uname -s)" == "MINGW64_NT" ]]
then
    check_if_win7
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >/dev/null ; fi
    debug "This version of Parmanode will not work on Windows. Aborting."
    exit 1
fi
debug"OS not detected. Aborting."
exit 1
}

function check_if_win7 {
# will return win7+, linux, or not_win string.
if [[ $(uname -s) == MINGW* ]] ; then
    version=$(wmic os get version | grep -oE "[0-9]+.[0-9]+")
    if (( $(echo "$version >= 6.1" | bc -l) )) ; then
        OS="Win"
    else
        OS="Win_old"
    fi
else
    OS="Not_Win"
fi
return 0
}

