function install_parmashell {
if [[ $1 != silent ]] ; then
parmashell_intro || return 1
fi

#back up original bashrc, being responsible and stuff.
if [[ $OS == Mac ]] ; then rc=zshrc ; fi
if [[ $OS == Linux ]] ; then rc=bashrc ; fi


#Do not change echo statements
if ! grep -q "Added by Parmanode below, safe to delete" < ~/.$rc ; then
cp ~/.$rc ~/.${rc}_parmanodebackup >/dev/null 2>&1
echo "#Added by Parmanode below, safe to delete..." | sudo tee -a ~/.$rc >/dev/null 
echo "source $HOME/parman_programs/parmanode/src/ParmaShell/parmashell_functions" | sudo tee -a ~/.$rc >/dev/null
echo "#Added by Parmanode above, safe to delete..." | sudo tee -a ~/.$rc >/dev/null
else
installed_config_add "parmashell-end" >/dev/null
return 1
fi

installed_config_add "parmashell-end" >/dev/null

if [[ $1 != silent ]] ; then
success "ParmaShell" "being installed"
announce "You may need to reload terminal to see the changes."
fi
}