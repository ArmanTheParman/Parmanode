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

cp "$HOEM/.$rc" "$HOME/.${rc}_uninstall_parmanodebackup"

#sed method compaitble with both mac and linux...
sudo sed '/Added by Parmanode below/,/Added by Parmanode above/d' "$HOME/.$rc" > "$HOME/.$rc2" 2>&1 \
&& mv "$HOME/.$rc2" "$HOME/.$rc"

sudo sed '/ParmaShell/d' "$HOME/.$rc" > "$HOME/.$rc2" 2>&1 \
&& mv "$HOME/.$rc2" "$HOME/.$rc"

debug "adjusted bashrc / zshrc; rc is $rc"
installed_config_remove "parmashell"
success "ParmaShell" "being uninstalled."
}

