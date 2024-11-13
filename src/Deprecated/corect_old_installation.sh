function correct_old_installation {

if [[ -d $HOME/parman_programs/parmanode ]] ; then return 0 ; fi

mkdir $HOME/parman_program
mv $original_dir $HOME/parman_programs/
rm $HOME/Desktop/run_parmanode*
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull >/dev/null 2>&1

}