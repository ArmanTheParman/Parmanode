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

if [[ $OS == Mac ]] ; then rc=zshrc ; fi
if [[ $OS == Linux ]] ; then rc=bashrc ; fi

sudo cp -rf "$HOME/.$rc" "$HOME/.${rc}_uninstall_parmanodebackup" >/dev/null 2>&1

#sed method compaitble with both mac and linux...
sudo gsed -i '/Added by Parmanode below/,/Added by Parmanode above/d' "$HOME/.$rc" 

sudo gsed -i '/ParmaShell/d' "$HOME/.$rc" 

installed_config_remove "parmashell"
if [[ $1 != silent ]] ; then
success "ParmaShell" "being uninstalled."
fi
}

