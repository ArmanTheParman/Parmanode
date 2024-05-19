function install_parmashell {
if [[ $1 != silent ]] ; then
parmashell_intro || return 1
fi

#back up original bashrc, being responsible and stuff.
if [[ $OS == Mac ]]   ; then rc=zshrc  ; fi
if [[ $OS == Linux ]] ; then rc=bashrc ; fi
if [[ ! -e ~/.$rc ]] ; then sudo touch ~/.$rc >/dev/null 2>&1 ; fi

#Do not change echo statements
if ! grep -q "Added by Parmanode below, safe to delete" < ~/.$rc >/dev/null 2>&1 ; then
cp ~/.$rc ~/.${rc}_parmanodebackup >/dev/null 2>&1
echo "#Added by Parmanode below, safe to delete..." | sudo tee -a ~/.$rc >/dev/null 2>&1
echo "source $HOME/parman_programs/parmanode/src/ParmaShell/parmashell_functions" | sudo tee -a ~/.$rc >/dev/null 2>&1
echo "#Added by Parmanode above, safe to delete..." | sudo tee -a ~/.$rc >/dev/null 2>&1
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