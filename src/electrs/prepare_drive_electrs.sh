function prepare_drive_electrs {

mkdir -p $HOME/.electrs

if [[ $drive_electrs == "internal" ]] ; then
        mkdir -p $HOME/parmanode/electrs/electrs_db && return 0
        #move backed up db directory here later if selected
fi


if [[ $drive_electrs == "external" ]] ; then
 return 0
 # drive preparation done in "restore_electrs_drive" 
fi  
}