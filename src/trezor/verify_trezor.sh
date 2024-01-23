function verify_trezor {

curl -L https://trezor.io/security/satoshilabs-2021-signing-key.asc | gpg --import

if ! gpg --verify *.asc 2>&1 | grep "Good" ; then 
announce "gpg check failed. aborting." 
return 1 
else
announce "gpg verification$green PASSED$orange."
fi

}