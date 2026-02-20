function prepare_drive_eps {

mkdir -p $HOME/.eps

if [[ $drive_eps == "internal" ]] ; then
        mkdir -p $HOME/.eps_db && return 0
        #move backed up db directory here later if selected
fi


if [[ $drive_eps == "external" ]] ; then
 return 0
fi  
}