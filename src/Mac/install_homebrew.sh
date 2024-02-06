function install_homebrew {
clear
echo -e "
########################################################################################

    Installing Homebrew package manager for Mac. 

    This can take a while, sometimes with very litte feedback during the process. 

    Hitting control-t while it's thinking might give some status update. 
    Please just wait.

########################################################################################    

    Hit <enter> to continue.

"
read

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 

}
