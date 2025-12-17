
function make_restricted_bucket2 {

sudo mkdir -p /usr/local/parmanode
sudo chown root:$(id -gn) /usr/local/parmanode
sudo chmod 750 /usr/local/parmanode

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

for dir in "$pn/restricted" "$pn/restricted/src" "$pn/restricted/scripts" ; do
     cd \$dir || exit 1

     for x in * ; do
         if [[ \$x =~ README ]] ; then continue ; fi
         if [[ \$x =~ ^sign$ ]] ; then continue ; fi
         if [[ \$x =~ \.sig$ ]] ; then continue ; fi
         if test -d $dir/$\x ; then continue ; fi 

         if ! gpgv --keyring /usr/local/parmanode/parman.gpg "\$x.sig" "\$x" >$dn 2>&1 ; then exit 1 ; fi

         sudo cp -r "\$dir/\$x" "/usr/local/parmanode/" >$dn 2>&1
         sudo chmod 750 "/usr/local/parmanode/\$x"
     done
done


chmod 750 /usr/local/parmanode/patch.sh
HOME=$HOME /usr/local/parmanode/patch.sh >>$dp/debug.log 2>&1
exit 0
EOF
sudo chmod 750 /usr/local/parmanode/patchrunner.sh
parmanode_conf_remove "restricted_bucket=true" #remove old flag
parmanode_conf_add "restricted_bucket_v2=true"
}