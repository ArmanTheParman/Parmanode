function fix {
#temporary help to get coldcard firmware.

cd /tmp
curl -LO https://coldcard.com/downloads/2023-12-21T1526-v5.2.2-mk4-coldcard.dfu
gpg --import $HOME/parman_programs/parmanode/src/special/ccpubkey.asc
cp $HOME/parman_programs/parmanode/src/special/signatures.txt /tmp/
gpg --verify signatures.txt || { announce "error. verification of signatures.txt failed." ; return 1 ; }
hash=$(shasum -a 256 2023-12-21T1526-v5.2.2-mk4-coldcard.dfu | awk '{print $1}')
grep -q $hash < ./signatures.txt || { announce "error. verification of the hash failed." ; return 1 ; }

}