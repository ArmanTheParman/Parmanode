
function make_restricted_bucket { debugf
if [[ $OS == "Mac" ]] ; then return 0 ; fi

#Old versions, clear previous files...
if grep -q restricted_bucket $pc ; then
  sudo rm -rf /usr/local/parmanode/* >/dev/null 2>&1
fi

sudo mkdir -p /usr/local/parmanode/{src,scripts,service}
sudo chown root:$(id -gn) /usr/local/parmanode/{src,scripts,service}
sudo chmod 750 /usr/local/parmanode/{src,scripts,service}

#Parman Pub Key Check and temp import
sudo cp $pn/src/keys/parman.asc /usr/local/parmanode/
if ! grep -q d88f138fb707f53fb106895a6891b3615494ec9e3a509988ab02aad93aef4edc <(shasum -a 256 /usr/local/parmanode/parman.asc) ; then 
    sudo rm -f /usr/local/parmanode/parman.asc >/dev/null 2>&1                      
    sww "Unexpect error with Parman's pubkey. Aborting restricted bucket function." 
    debug
    return 1
fi
sudo gpg --no-default-keyring --keyring /usr/local/parmanode/parman.gpg --import /usr/local/parmanode/parman.asc >$dn 2>&1
debug
#make script to move files into restricted location for sudoers to use
   # check existing files in $pn/restriced, except README
   # do signature verification, then copy bytes to new location (before releasing file descriptor).
   # add sudoers command to run said script

cat <<EOF | sudo tee /usr/local/parmanode/scripts/patchrunner.sh >$dn
#!/bin/bash

for dir in "$pn/restricted" "$pn/restricted/src" "$pn/restricted/scripts" ; do
     cd \$dir || continue #if dir is a file, continue the loop, only want directories

     for x in * ; do  #after cd into a directory, loop the files...
         if [[ \$x =~ README ]] ; then continue ; fi
         if [[ \$x =~ ^sign$ ]] ; then continue ; fi
         if [[ \$x =~ \.sig$ ]] ; then continue ; fi

         if test -d \$dir/\$x ; then continue ; fi #skip directory verification #check it's not a directory otherwise continue loop

         if ! gpgv --keyring /usr/local/parmanode/parman.gpg "\$x.sig" "\$x" >$dn 2>&1 ; then exit 1 ; fi
         
         #copy the files...
         if [[ \$dir =~ src$ ]] ; then
               sudo cp -r "\$dir/\$x" "/usr/local/parmanode/src/\$x" >$dn 2>&1
               sudo chmod 750 "/usr/local/parmanode/src/\$x"
            elif [[ \$dir =~ scripts$ ]] ; then
               sudo cp -r "\$dir/\$x" "/usr/local/parmanode/scripts/\$x" >$dn 2>&1
               sudo chmod 750 "/usr/local/parmanode/scripts/\$x"
            else
               sudo cp -r "\$dir/\$x" "/usr/local/parmanode/\$x" >$dn 2>&1
               sudo chmod 750 "/usr/local/parmanode/\$x"
         fi

     done
done

/usr/local/parmanode/patch.sh >/dev/null 2>&1
exit 0
EOF
sudo chmod 750 /usr/local/parmanode/scripts/patchrunner.sh >$dn 2>&1 #should exist in sudoers
sudo /usr/local/parmanode/scripts/patchrunner.sh >$dn 2>&1 #run once
parmanode_conf_remove "restricted_bucket=true" #remove old flag
parmanode_conf_add "restricted_bucket_v2=true"
}
