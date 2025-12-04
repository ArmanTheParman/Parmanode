function patch_10 { debugf
return 0
udev_patch  #then change udev function too.
make_mount_check_script #fixed any glitches by remaking it
openssh_patch
sudo chmod 440 /private/etc/sudoers.d/parmanode_extend_sudo_timeout

#remove duplicates in torrc, makes it crap its pants.

while [[ $(sudo grep -E "^ControlPort 9051" $torrc | wc -l) -gt 1 ]] ; do
    temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^ControlPort[[:space:]]9051 ]] ; then let count++ ; if [[ $count == 2 ]] ; then continue ; fi ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
done

rm $temp
while [[ $(sudo grep -E "^CookieAuthentication 1" $torrc | wc -l) -gt 1 ]] ; do
    temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^CookieAuthentication[[:space:]]1 ]] ; then let count++ ; if [[ $count == 2 ]] ; then continue ; fi ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
done
rm $temp

while [[ $(sudo grep -E "^CookieAuthFileGroupReadable 1" $torrc | wc -l) -gt 1 ]] ; do 
    temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^CookieAuthFileGroupReadable[[:space:]]1 ]] ; then let count++ ; if [[ $count == 2 ]] ; then continue ; fi ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
done
rm $temp

while [[ $(sudo grep -E "^DataDirectoryGroupReadable 1" $torrc | wc -l) -gt 1 ]] ; do 
    temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^DataDirectoryGroupReadable[[:space:]]1 ]] ; then let count++ ; if [[ $count == 2 ]] ; then continue ; fi ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
done
rm $temp

parmanode_conf_remove "patch="
parmanode_conf_add "patch=10"
}