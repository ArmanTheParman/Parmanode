function install_homebrew {
set_terminal
echo -e "

    Installing Homebrew package manager for Mac. 

    This can take a while with very litte feedback during the process. 
    Hitting control-t while its thinking might give some status update. 
    Please just wait.

"
enter_continue
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && return 0

}