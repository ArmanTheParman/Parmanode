function verify_green {

curl -LO https://github.com/Blockstream/green_qt/releases/download/release_$green_version/SHA256SUMS.asc
gpg --keyserver keyserver.ubuntu.com --recv-keys 04BEBF2E35A2AF2FFDF1FA5DE7F054AA2E76E792
gpg --verify SHA256SUMS.asc || { enter_continue "gpg verification failed. Aborting." ; return 1 ; }

if which sha256sum >$dn ; then
    hash=$(sha256sum SHA256SUMS.asc | awk '{print $1}')
elif which shasum >$dn ; then
    hash=$(shasum -a 256 SHA256SUMS.asc | awk '{print $1}')
fi

if ! grep -q $hash ./SHA256SUMS.asc ; then
    announce "The sha256 hash check failed. Aborting."
    return 1 
fi

return 0
}