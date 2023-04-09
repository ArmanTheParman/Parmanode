function check_if_win7 {
# will return win7+, linux, or not_win string.
if [[ $(uname -s) == MINGW* ]]; then
    version=$(wmic os get version | grep -oE "[0-9]+.[0-9]+")
    if (( $(echo "$version >= 6.1" | bc -l) )); then
        debug_point "windows"
        exit 1 
    else
        debug_point "win_old"
        exit 1
    fi
else
    debug_point "not_win. Unknown OS"
    exit 1
fi
}

################################################################################################

function which_os {
# Check if the OS is macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "mac"

# Check if the OS is Linux
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    echo "linux"

# Check if the OS is Windows
elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" || "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]]; then
    check_if_win7

else
    debug_point "This is an unknown OS"
    exit 1
fi
}