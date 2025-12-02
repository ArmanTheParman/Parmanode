function add_rp_function { debugf

if [[ ! -e $bashrc ]] ; then sudo touch $bashrc ; fi

if cat $bashrc 2>$dn | grep -q run_parmanode.sh ; then return 0 ; fi

if ! cat $bashrc 2>$dn | grep -q "#Added by Parmanode..." ; then
echo "#Added by Parmanode..." | sudo tee -a $bashrc >$dn 2>&1
echo 'function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh $@ ; }' | sudo tee -a $bashrc >$dn 2>&1
fi
}
