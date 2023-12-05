function uninstall_parmashell {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall ParmaShell 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

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

