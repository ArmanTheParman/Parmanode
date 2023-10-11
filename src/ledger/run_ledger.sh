function run_ledger {

if [[ $OS == Mac ]] ; then
open /Applications/"Ledger Live"*
fi

if [[ $OS == Linux ]] ; then
$HOME/parman_programs/ledger/*AppImage
fi

}