# A file to be stored on parmanode.com to help user troubleshoot/fix issues.
# User to run the command:
# curl https://parmanode.com/fix.sh | sh

# To prevent parmanode software sourcing the code below return...
return 0

# start here...

#!/bin/bash
cd ~/parman_programs/parmanode
if ! git config --global user.email ; then git config --global user.email sample@parmanode.com ; fi
if ! git config --global user.name ; then git config --global user.name Parman ; fi
git pull
