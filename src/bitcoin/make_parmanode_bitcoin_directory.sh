function make_parmanode_bitcoin_directory {

if [[ -d $HOME/parmanode/bitcoin ]] 
then 
            rm -rf $HOME/parmanode/bitcoin/* > /dev/null 2>&1
else
            mkdir $HOME/parmanode/bitcoin > /dev/null 2>&1
fi

installed_config_add "bitcoin-start"
#First significant install "change" made to drive

return 0
}