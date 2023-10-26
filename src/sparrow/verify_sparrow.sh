function verify_sparrow {

curl https://keybase.io/craigraw/pgp_keys.asc | gpg --import

if ! gpg --verify sparrow*.asc sparrow*.txt >/dev/null 2>&1 ; then
set_terminal ; echo "GPG verification failed. Aborting. Contact Parman for help." ; enter_continue ; return 1 ; fi

if ! shasum -a 256 --ignore-missing --check *parrow*.txt ; then echo "Checksum failed. Aborting. Contact Parman for help" 
enter_continue ; return 1 ; fi

}