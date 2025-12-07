
function make_restricted_bucket {

sudo mkdir -p /usr/local/parmanode
sudo chown root:$(id -gn) /usr/local/parmanode
sudo chmod 710 /usr/local/parmanode

#Parman Pub Key Check and temp import
sudo cp -f $pn/src/keys/parman.asc /usr/local/parmanode/
sudo cp $pn/src/keys/parman.asc /usr/local/parmanode/
if ! grep -q d88f138fb707f53fb106895a6891b3615494ec9e3a509988ab02aad93aef4edc <(shasum -a 256 /usr/local/parmanode/parman.asc) ; then 
    sudo rm -f /usr/local/parmanode/parman.asc >/dev/null 2>&1                      
    sww "error with parman's pubkey. exiting." 
    debug
    exit 1
fi
sudo gpg --no-default-keyring --keyring /usr/local/parmanode/parman.gpg --import /usr/local/parmanode/parman.asc >$dn 2>&1
debug
#make script to move files into restricted location for sudoers to use
   # check existing files in $pn/restriced, except README
   # do signature verification, then copy bytes to new location (before releasing file descriptor).
   # add sudoers command to run said script

cat <<EOF | sudo tee /usr/local/parmanode/patchrunner.sh >$dn
#!/bin/bash

while true ; do

   # These files must exist
   test -f $pn/restricted/patch.sh || break
   test -f $pn/restricted/patch.sh.sig || break

   cp -f $pn/restricted/patch.sh{,.sig} /usr/local/parmanode/ >/dev/null 2>&1

   if ! gpgv --keyring /usr/local/parmanode/parman.gpg /usr/local/parmanode/patch.sh.sig /usr/local/parmanode/patch.sh >/dev/null 2>&1 ; then
      #files exist and key doesn't match - that's bad.
      rm /usr/local/parmanode/patch.sh{,.sig} >/dev/null 2>&1
      exit 1 
   else
      # run patch at the end
      break
   fi

break
done

while true ; do

   file="$pn/restricted/p4run"
   filefinal=/usr/local/parmanode/p4run

   test -f \$file || break
   test -f \$file.sig || break

   cp -f "\$file" "\$filefinal" >/dev/null 2>&1
   cp -f "\$file.sig" "\$filefinal.sig" >/dev/null 2>&1
   chown root:$(id -gn) "\$filefinal"
   chmod 710 "\$filefinal"

   if ! gpgv --keyring /usr/local/parmanode/parman.gpg \$filefinal.sig \$filefinal ; then
      rm \$filefinal{,.sig} >/dev/null 2>&1
      exit 1
   else
      break   
   fi

   break

done

/usr/local/parmanode/patch.sh >$pn/debug.log 2>&1
exit 0
EOF
sudo chmod 710 /usr/local/parmanode/patchrunner.sh
parmanode_conf_add "restricted_bucket=true"
}