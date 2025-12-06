function fix_torrc {
#remove duplicates in torrc, makes it crap its pants.
sudo cp $torrc $torrc.bak
temp=$(mktemp) 
while [[ $(sudo grep -E "^ControlPort 9051" $torrc | wc -l) -gt 1 ]] ; do
    count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^ControlPort[[:space:]]9051 ]] ; then let count++ ; if [[ $count == 2 ]] ; then continue ; fi ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
sudo mv $temp $torrc
done

temp=$(mktemp) 
while [[ $(sudo grep -E "^CookieAuthentication 1" $torrc | wc -l) -gt 1 ]] ; do
    export temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^CookieAuthentication[[:space:]]1 ]] ; then let count++ ; if [[ $count == 2 ]] ; then continue ; fi ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
sudo mv $temp $torrc
done
temp=$(mktemp) 
while [[ $(sudo grep -E "^CookieAuthFileGroupReadable 1" $torrc | wc -l) -gt 1 ]] ; do 
    export temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^CookieAuthFileGroupReadable[[:space:]]1 ]] ; then let count++ ; if [[ $count == 2 ]] ; then continue ; fi ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
sudo mv $temp $torrc
done
temp=$(mktemp) 
while [[ $(sudo grep -E "^DataDirectoryGroupReadable 1" $torrc | wc -l) -gt 1 ]] ; do 
    export temp=$(mktemp) ; count=0
    while IFS= read -r x ; do
       if [[ $x =~ ^DataDirectoryGroupReadable[[:space:]]1 ]] ; then let count++ ; if [[ $count == 2 ]] ; then continue ; fi ; fi
       echo "$x" >> $temp
    done < <(sudo cat $torrc)
sudo mv $temp $torrc
done

rm $temp 2>$dn

}