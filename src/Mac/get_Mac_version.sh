function get_Mac_version {
if [[ $(uname) != Darwin ]] ; then return 0 ; fi

export MacOSVersion=$(sw_vers | grep ProductVersion | awk '{print $ 2}')
export MacOSVersion_major=$(sw_vers | grep ProductVersion | cut -d \. -f 1)
export MacOSVersion_minor=$(sw_vers | grep ProductVersion | cut -d \. -f 2)
export MacOSVersion_patch=$(sw_vers | grep ProductVersion | cut -d \. -f 3)

if [[ ($MacOSVersion -lt 10) || ($MacOSVersion == 10 && $MacOSVersion_major -lt 9) ]] ; then
set_terminal
echo "
########################################################################################

    Sorry, you need MacOS version 10.9 or later to use Parmanodce.

########################################################################################
    Hit <enter> to continue.
"
read
exit 0
fi
}