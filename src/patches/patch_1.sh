function patch_1 {

#rm_after_before
turn_off_spotlight
add_rp_function
correct_old_installation
parmanode_conf_add "patch=1"
}


function rm_after_before {
rm $dp/after >/dev/null 2>&1
rm $dp/before >/dev/null 2>&1
}

function turn_off_spotlight {

if [[ $OS != Mac ]] ; then return 0 ; fi

if sudo mdutil -s $parmanode_drive | grep -q disabled ; then #checks status of spotlight on drive
   return 0
else
   sudo mdutil -i off $parmanode_drive >/dev/null 2>&1 #turns off spotlight
   sudo mdutil -E $parmanode_drive >/dev/null 2>&1 #erase existing spotlight index
fi
}

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

function correct_old_installation {

if [[ -d $HOME/parman_programs/parmanode ]] ; then return 0 ; fi

mkdir $HOME/parman_program
mv $original_dir $HOME/parman_programs/
rm $HOME/Desktop/run_parmanode*
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull >/dev/null 2>&1

}