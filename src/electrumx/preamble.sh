function preamble {
set_terminal

if [[ $1 == electrumx ]] ; then
echo -e "
########################################################################################

    Electrum X is one of several types of Electrum SERVERS. It takes data from a 
    Bitcoin Node (preferably yours!) and makes it's own database - same info but
    organised differntly, allowing efficient communication with wallets.

    In some cases querying your own Electrum Server is more private that querying
    your own Bitcoin Node - something to do with your wallet information being stored
    in an encrypted fashion rather than clear text; I have looked too much into the
    details, so the education about that stops here.
    
    The main reason is that you'll have a faster experience with your wallet. There
    is not reason to have more than one Electrum server RUNNING, but you might like
    to install various servers as sometimes the database can get corrupted, so it's
    nice to have a spare.
    
    The reason you might want to specifically choose Electrum X over the others,
    as far as I know, is that this one is the most powerful choice, and the one that
    "all" the public servers run.

########################################################################################
"
enter_continue
fi
    
}