function which_os {
if [[ "$(uname -s)" == "Darwin" ]]
then
    OS="Mac"
    return 0 
fi

if [[ "$(uname -s)" == "Linux" ]]
then
    OS="Linux"
    return 0
fi

if [[ "$(uname -s)" == "MINGW32_NT" || "$(uname -s)" == "MINGW64_NT" ]]
then
    check_if_win7
    debug_point "This version of Parmanode will not work on Windows. Aborting."
    exit 1
fi
debug_point "OS not detected. Aborting."
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

