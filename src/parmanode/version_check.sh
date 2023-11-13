function update_version_info {
unset version_incompatibility latest_version version old_version 
unset latest_vMajor vMajor latest_vMinor vMinor latest_vPatch vPatch

#called by run_parmanode/do_loop

#must be in this order
export_latest_version
export_local_version
check_backwards_compatibility
if [[ $version_incompatibility != 1 ]] ; then
    check_for_updates

        if [[ $old_version == 1 ]] ; then
            old_version_detected
        fi
fi
}

function check_for_updates {
if [[ $latest_version != $version ]] ; then
    export old_version=1
    return 0
    fi
}

function old_version_detected {
if ! git status | grep "On branch" | grep master >/dev/null ; then return 0 ; fi
while true ; do
set_terminal ; echo "
########################################################################################

    The version of Parmanode you are running is not up to date. Would you like to
    update Parmanode now? 

                y)         Yes
                
                n)         No 
    
    The apps you have already installed will not be changed.

########################################################################################
"
choose "xq" ; read choice
case $choice in
N|no|NO|No|n) return 0 ;;
y|Y|YES|Yes|yes) update_parmanode ; return 0 ;;
*) invalid ;;
esac
done
}

function check_backwards_compatibility {
if [[ $latest_vMajor -lt $vMajor ]] ; then
export version_incompatibility=1
fi
}

function export_latest_version {
curl -s https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/version.conf > /tmp/latest_version.txt
source /tmp/latest_version.txt && rm /tmp/latest_version.txt >/dev/null
export latest_version="$version" >/dev/null
export latest_vMajor="$vMajor" >/dev/null
export latest_vMinor="$vMinor" >/dev/null
export latest_vPatch="$vPatch" >/dev/null
}

function export_local_version {
source $original_dir/version.conf >/dev/null 2>&1
export version ; export vMajor ; export vMinor ; export vPatch

}
