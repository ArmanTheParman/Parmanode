
function check_if_win7 {
# will return win7+, linux, or not_win string.
if [[ $(uname -s) == MINGW* ]] ; then
    version=$(wmic os get version | grep -oE "[0-9]+.[0-9]+")
    if (( $(echo "$version >= 6.1" | bc -l) )) ; then
        echo "win"
    else
        echo "win_old"
    fi
else
    echo "not_win"
fi
return 0
}


function which_os {
# Check if the OS is macOS
if [[ "$(uname -s)" == "Darwin" ]]
then
    echo "mac"
fi

# Check if the OS is Linux
if [[ "$(uname -s)" == "Linux" ]]
then
    echo "linux"
fi

# Check if the OS is Windows
if [[ "$(uname -s)" == "MINGW32_NT" || "$(uname -s)" == "MINGW64_NT" ]]
then
    x=$(check_if_win7)
    echo $x
    # will return win7+, linux, or not_win string.
fi
return 0
}
