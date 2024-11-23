#script kep at parmanode.com

#!/bin/bash
clear
cd $HOME

git clone https://github.com/armantheparman/parmanode.git parmanode_temp

#command to check download successful...
file $HOME/parmanode_temp/version.conf >$dn 2>&1 || { echo "Some problem with the download. Aborting. You might wnat to try again later." ; sleep 5 ; exit ; }

#delete original faulty directory
sudo rm -rf $HOME/parman_programs/parmanode >$dn 2>&1

# just in case...
mkdir -p parman_programs >$dn 2>&1

mv $HOME/parmanode_temp/ $HOME/parman_programs/parmanode >$dn 2>&1

cd $HOME/parman_programs/parmanode
git config pull.rebase false >$dn 2>&1
if ! git config user.email >$dn 2>&1 ; then git config user.email sample@parmanode.com ; fi
if ! git config user.name  >$dn 2>&1 ; then git config user.name ParmanodeUser ; fi
echo "

"
echo "The Parmanode directory has been refreshed and updated."
exit
