function uninstall_parmashell {
if [[ $1 != silent ]] ; then
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
fi

sudo gsed -i '/Added by Parmanode below/,/Added by Parmanode above/d' "$bashrc"
sudo gsed -i '/ParmaShell/d' "$bashrc"

installed_config_remove "parmashell"
if [[ $1 != silent ]] ; then
success "ParmaShell" "being uninstalled."
fi
}

