function verify_sparrow {

curl https://keybase.io/craigraw/pgp_keys.asc | gpg --import

if ! gpg --verify sparrow*.asc sparrow*.txt >/dev/null 2>&1 ; then
set_terminal ; echo "GPG verification failed. Aborting. Contact Parman for help." ; enter_continue ; return 1 ; fi

if which sha256sum >/dev/null ; then
    if ! sha256sum --ignore-missing --check *parrow*.txt ; then echo -e "Checksum$red failed$orange. Aborting. Contact Parman for help." 
    enter_continue ; return 1 ; fi
else
    if ! shasum -a 256 --check *parrow*.txt | grep -q OK ; then echo "Checksum$red failed$orange. Aborting. Contact Parman for help." 
    enter_continue ; return 1 ; fi
fi


}