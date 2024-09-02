function install_homebrew {
clear
echo -e "
########################################################################################

    Installing$cyan Homebrew$orange package manager for Mac. 

    This can take a while, sometimes with very litte feedback during the process. 

    Hitting control-t while it's thinking might give some status update. 

    You may or may not need to respond to some prompts.

########################################################################################    

    Hit <enter> to continue.

"
read

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 

echo "PATH=\$PATH:/opt/homebrew/bin" | sudo tee -a $HOME/.zshrc >$dn 2>&1

echo "
You may get a prompt to update the PATH - don't worry, Parmanode has done 
it for you."
enter_continue
}
