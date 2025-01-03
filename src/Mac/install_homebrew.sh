function install_homebrew {
clear
echo -e "
########################################################################################

    Installing$cyan Homebrew$orange package manager for Mac. 

    This can take a while, sometimes with very litte feedback during the process. 

    Hitting$cyan control-t$orange while it's thinking might give some status update. 

    You may or may not need to respond to some prompts.

########################################################################################    
"
enter_continue

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 

echo "PATH=/opt/homebrew/bin:\$PATH" | sudo tee -a $HOME/.zshrc >$dn 2>&1

echo "
You may get a prompt to update the PATH - don't worry, Parmanode has done 
it for you."
enter_continue
}
