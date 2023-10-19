function verify_bitbox {

curl https://bitbox.swiss/download/shiftcryptosec-509249B068D215AE.gpg.asc | gpg --import

if ! gpg --verify --status-fd 1 SHA256SUMS.asc  2>&1 | grep -q GOOD ; then
announce "gpg verification failed. Aborting."
return 1
else
announce "gpg verification PASSED."
fi

}