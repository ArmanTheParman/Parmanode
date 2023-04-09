function prepare_internal_drive {
clear
echo "
Directories will be created in $HOME/parmanode/
"
if [[ -d $HOME/parmanode/ ]] ; then return 0 ; else cd $HOME && mkdir parmanode ; fi
if [[ -d $HOME/parmanode/bitcoin_data ]] ; then return 0 ; else cd $HOME/parmanode/ ; mkdir bitcoin_data ; fi

echo "

done."

read - p "Hit <enter> to continue."

}