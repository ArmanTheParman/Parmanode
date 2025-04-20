function install_homebrew {
clear
while true ; do
echo -e "
########################################################################################$cyan
                              HOMEBREW INSTALLATION$orange
########################################################################################

    Homebrew is a package manager for macOS. It is used to install and manage software.

    This can take a while, sometimes with very litte feedback during the process. 

    Hitting$cyan control-t$orange while it's thinking might give some status update. 

    You may or may not need to respond to some prompts; if there is a recommendation 
    to run a command related to 'git unshallow', then follow that instruction.

    Proceed or abort it?
$green
                             yes)$orange    Install Homebrew
$red
                             no)$orange     Skip (exit)

########################################################################################    
"
read choice ; set_terminal
case $choice in
q|Q) exit ;; n|No|no) exit ;; 
yes)

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 

echo "PATH=/opt/homebrew/bin:\$PATH" | sudo tee -a $HOME/.zshrc >$dn 2>&1

echo "
You may get a prompt to update the PATH - don't worry, Parmanode has done 
it for you."
enter_continue
install_homebrew_packages

success "Parmanode has completed installing Homebrew for you."
return 0
;;
*)
invalid
;;
esac
done

}


   