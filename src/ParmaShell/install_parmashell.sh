function install_parmashell {
if grep -q "parmashell-end" $ic ; then return ; fi

#back up original bashrc, being responsible and stuff.
if [[ ! -e $bashrc ]] ; then sudo touch $bashrc >/dev/null 2>&1 ; fi

if grep -q "parmashell_functions" $bashrc ; then return 0 ; fi

#Do not change echo statements
if ! grep -q "Added by Parmanode below, safe to delete" $bashrc >/dev/null 2>&1 ; then
echo "#Added by Parmanode below, safe to delete..." | sudo tee -a $bashrc >/dev/null 2>&1
echo "source $HOME/parman_programs/parmanode/src/ParmaShell/parmashell_functions" | sudo tee -a $bashrc >/dev/null 2>&1
echo "#Added by Parmanode above, safe to delete..." | sudo tee -a $bashrc >/dev/null 2>&1
else
installed_config_add "parmashell-end" >/dev/null
return 1
fi

installed_config_add "parmashell-end" >/dev/null

}