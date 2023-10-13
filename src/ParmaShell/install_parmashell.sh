function install_parmashell {

parmashell_intro || return 1
#back up original bashrc, being responsible and stuff.
if [[ $OS == Mac ]] ; then rc=zshrc ; fi
if [[ $OS == Linux ]] ; then rc=bashrc ; fi

cp ~/.$rc ~/.${rc}_parmanodebackup

echo "#Added by Parmanode below, safe to delete..." | sudo tee -a ~/.$rc >/dev/null
installed_config_add "parmashell-start"
echo "source $HOME/parman_programs/parmanode/src/ParmaShell/parmashell_functions" | sudo tee -a ~/.$rc >/dev/null
echo "#Added by Parmanode above, safe to delete..." | sudo tee -a ~/.$rc >/dev/null

installed_config_add "parmashell-end"
success "ParmaShell" "being installed"
announce "You may need to reload terminal to see the changes."
}