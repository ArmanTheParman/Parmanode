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
        if [[ $vMajor -gt $latest_vMajor ]] ; then return 0 ; fi
        if [[ $vMajor -lt $latest_vMajor ]] ; then old_version_detected ; return 0 ; fi
        if [[ $vMinor -gt $latest_vMinor ]] ; then return 0 ; fi
        if [[ $vMinor -lt $latest_vMinor ]] ; then old_version_detected ; return 0 ; fi
        if [[ $vPatch -gt $latest_vPatch ]] ; then return 0 ; fi
        if [[ $vPatch -lt $latest_vPatch ]] ; then old_version_detected ; fi
    fi
fi
}

function check_for_updates {
if [[ $latest_version != $version ]] ; then
debug2 "check_for_updates: latest version $latest_version != version $version
$(cd $pn ; git status | grep 'Your branch is')
"
cd -
    export old_version=1
    return 0
    fi
}

function old_version_detected {
countversion=0
if ! git status | grep "On branch" | grep master >$dn ; then return 0 ; fi
while true ; do
if [[ $countversion -gt 0 ]] ; then announce "If you're stuck in a loop, check 'git status' in the
    Parmanode directory. If you've been editing files, that can cause issues. 
    Just delete the Parmanode directory and clone it form github again:

    cd $HOME/parman_programs && git clone --depth 1 https://github.com/armantheparman/parmanode.git
    "
fi
countversion=$((countversion + 1))
if sudo cat /etc/crontab | grep -q parmanode ; then
au_message="$pink
                on)        Turn on auto-updates
$orange"
fi
set_terminal ; echo -en "
########################################################################################

    The version of Parmanode you are running is$red not up to date$orange. Would you like to
    update Parmanode now? 
$green
                y)         Yes
     $orange           
                n)         No 
$au_message
    The apps you have already installed will not be changed.


    Latest Avaliavble:   $cyan$latest_version$orange
    Your Version:        $red$version$orange

########################################################################################
"
choose "xq" ; read choice
case $choice in
N|no|NO|No|n) return 0 ;;
y|Y|YES|Yes|yes) 
clear
update_parmanode refresh ; return 0 ;;
on)
autoupdate on
break
;;
*) 
invalid ;;
esac
done
}

function check_backwards_compatibility {
if [[ $latest_vMajor -lt $vMajor ]] ; then
export version_incompatibility=1
fi
}

function export_latest_version {
unset latest_version
rm $tmp/latest_version.txt 2>$dn
curl -sL -H 'Cache-Control: no-cache, no-store, must-revalidate' https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/version.conf > $tmp/latest_version.txt
source $tmp/latest_version.txt && rm $tmp/latest_version.txt >$dn
export latest_version="$version"
export latest_vMajor="$vMajor"
export latest_vMinor="$vMinor" 
export latest_vPatch="$vPatch"
debug2 "export latest version: $latest_version $latest_vMajor $latest_vMinor $latest_vPatch, $version $vMajor $vMinor $vPatch"
}

function export_local_version {
source $pn/version.conf >$dn 2>&1
export version ; export vMajor ; export vMinor ; export vPatch
debug2 "export local version $version $vMajor $vMinor $vPatch"

}
