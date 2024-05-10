#script kep at parmanode.com

#!/bin/bash
cd $HOME
git clone https://github.com/armantheparman/parmanode.git parmanode_temp
cat ./parmanode_temp/do_not_delete_move_rename.txt 2>/dev/null || { echo "Some problem with the download. Aborting. You might wnat to try again later." ; sleep 5 ; exit ; }
rm -rf $HOME/parman_programs/parmanode >/dev/null 2>&1
mkdir -p parman_programs >/dev/null 2>&1
mv $HOME/parmanode_temp/ $HOME/parman_programs/parmanode >/dev/null 2>&1
echo "The Parmanode directory has been refreshed and updated."
exit
