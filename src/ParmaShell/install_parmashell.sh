function install_parmashell {
if grep -q "parmashell-end" $ic 2>$dn ; then return ; fi

#back up original bashrc, being responsible and stuff.
if [[ ! -e $bashrc ]] ; then sudo touch $bashrc >$dn 2>&1 ; fi

if grep -q "parmashell_functions" $bashrc 2>$dn  ; then return 0 ; fi

#Do not change echo statements
if ! grep -q "Added by Parmanode below, safe to delete" $bashrc >$dn 2>&1 ; then
echo "#Added by Parmanode below, safe to delete..." | sudo tee -a $bashrc >$dn 2>&1
echo "source $HOME/parman_programs/parmanode/src/ParmaShell/parmashell_functions" | sudo tee -a $bashrc >$dn 2>&1
echo "#Added by Parmanode above, safe to delete..." | sudo tee -a $bashrc >$dn 2>&1
else
installed_config_add "parmashell-end" >$dn
return 1
fi

installed_config_add "parmashell-end" >$dn

}