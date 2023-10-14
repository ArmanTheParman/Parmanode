function uninstall_parmashell {

if [[ $OS == Mac ]] ; then rc=zshrc ; fi
if [[ $OS == Linux ]] ; then rc=bashrc ; fi

cp ~/.$rc ~/.${rc}_uninstall_parmanodebackup

sudo sed '/Added by Parmanode/d' ~/.$rc > ~/.$rc2 2>&1 \
&& mv ~/.$rc2 ~/.$rc

sudo sed '/ParmaShell/d' ~/.$rc > ~/.$rc2 2>&1 \
&& mv ~/.$rc2 ~/.$rc

installed_config_remove "parmashell"
success "ParmaShell" "being uninstalled."
}

