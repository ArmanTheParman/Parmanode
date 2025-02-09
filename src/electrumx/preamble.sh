function preamble {
set_terminal

if [[ $1 == electrumx ]] ; then
echo -e "
########################################################################################

    Electrum X is a type of Electrum server designed to interface with a Bitcoin node 
    (ideally your own!). It processes data from the node to build its own optimized 
    database, reorganizing blockchain information to enable faster, more efficient 
    communication with wallets like Electrum.

    A key advantage of using your own Electrum server over querying a Bitcoin node 
    directly is enhanced privacy. Electrum servers handle wallet data more securely—
    for example, encrypting interactions that might otherwise be in plaintext. While 
    the technical specifics are beyond this overview, this privacy layer is a benefit.  

    The primary reason to run an Electrum server is performance. Electrum X streamlines 
    wallet synchronization and queries, offering a smoother experience. While only one 
    server is needed, maintaining backups can prevent downtime if database corruption 
    occurs, though rare.  

    Among Electrum servers, Electrum X is the most robust and widely adopted, powering 
    nearly all public servers. Its maturity and scalability make it the default choice 
    for reliability and compatibility.

########################################################################################
"
enter_continue ; jump $enter_cont
fi
}
