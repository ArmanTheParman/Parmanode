function verify_bitbox {

curl https://bitbox.swiss/download/shiftcryptosec-509249B068D215AE.gpg.asc | gpg --import

if ! gpg --verify --status-fd 1 B*.asc  2>&1 | grep -iq GOOD ; then
sww "gpg verification$red failed$orange. Aborting."
return 1
else
short_announce "gpg verification ${green}PASSED.$orange" "4"
fi
}