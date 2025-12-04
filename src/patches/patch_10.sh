function patch_10 { debugf

udev_patch  #then change udev function too.
make_mount_check_script #fixed any glitches by remaking it
openssh_patch
sudo chmod 440 /private/etc/sudoers.d/parmanode_extend_sudo_timeout

#remove duplicates in torrc, makes it crap its pants.

if [[ $(sudo grep -E "^ControlPort 9051" $torrc | wc -l) -gt 1 ]] ; then
    temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^ControlPort 9051 ]] ; then let count++ ; if [[ $count == 2 ]] ; then continue ; fi ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
fi

if [[ $(sudo grep -E "^CookieAuthentication 1" $torrc | wc -l) -gt 1 ]] ; then
    temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^CookieAuthentication 1 ]] ; then continue ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
fi

if [[ $(sudo grep -E "^CookieAuthFileGroupReadable 1" $torrc | wc -l) -gt 1 ]] ; then
    temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^CookieAuthFileGroupReadable 1 ]] ; then continue ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
fi

if [[ $(sudo grep -E "^DataDirectoryGroupReadable 1" $torrc | wc -l) -gt 1 ]] ; then
    temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^DataDirectoryGroupReadable 1 ]] ; then continue ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
fi



parmanode_conf_remove "patch="
parmanode_conf_add "patch=10"
}