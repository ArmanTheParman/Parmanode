function add_rp_function {
if [[ $(uname) == Darwin ]] ; then rc=zshrc ; fi
if [[ $(uname) == Linux ]] 
then 
    rc=bashrc
    if [[ ! -e $HOME/.bashrc ]] ; then touch $HOME/.bashrc ; fi 
fi

if [[ ! -e $HOME/.$rc ]] ; then touch $HOME/.$rc ; fi

if grep -q run_parmanode.sh < ~/.$rc ; then return 0 ; fi

if ! grep "#Added by Parmanode..." < $HOME/.$rc ; then
echo "#Added by Parmanode..." | tee -a ~/.$rc >/dev/null 2>&1
echo 'function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh $@ ; }' | tee -a ~/.$rc >/dev/null 2>&1
fi
}
    

    

    

    
