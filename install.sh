# This is the install script kept at
# https://parmanode.com/install.sh - the URL is easier to remember and shorter than if keeping it on Github.


sudo apt update -y 
sudo apt install git -y
mkdir $HOME/parman_programs ; cd ; cd parman_programs
git clone https://github.com/armantheparman.com/parmanode.git

echo '#!/bin/bash' > ~/Desktop/run_parmanode.sh
echo "cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh" >> $HOME/Desktop/run_parmanode.sh
sudo chmod +x $HOME/Desktop/run_parmanode.sh
exit