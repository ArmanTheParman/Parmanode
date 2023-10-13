function uninstall_parmashell {

if [[ $OS == Mac ]] ; then rc=zshrc ; fi
if [[ $OS == Linux ]] ; then rc=bashrc ; fi

cp ~/.$rc ~/.${rc}_uninstall_parmanodebackup

sudo sed '/Added by Parmanode/d' ~/.$rc > ~/.$rc 2>&1
sudo sed '/ParmaShell/d' ~/.$rc > ~/.$rc 2>&1
installed_config_remove "parmashell"
success "ParmaShell" "being uninstalled."
}

