function compile_electrs {
set_terminal ; echo "   Compiling electrs..."
please_wait ; echo ""
cd $HOME/parmanode/electrs && cargo build --locked --release > /tmp/cargo_build.log
if [[  ! -e $HOME/parmanode/electrs/target/release/electrs ]] ; then
    if grep -q "perhaps you ran out of disk space" < /tmp/cargo_build.log ; then 
        announce "Compiling seems to have failed. Aborting." \
        "It might be because you ran out of disk space."
        return 1
    else
        enter_continue 
        set_terminal ; echo -e "
########################################################################################
$red
    Compiling electrs seems to have failed.$orange This can happen as there is much 
    variability between systems and not everthing can be anticipated.

    You have options...

        1) Uninstall this partial installation yourself from the remove menu, 
           and try again (sometimes works)

        2) Uninstall this partial installation yourself, and install the Docker
           version of electrs instead. Docker is a container with an operating system
           which which is identical between systems, reduces chances of installation
           failure.
        
        3) Install Fulcrum instead of electrs

        4) Put computer in the bin (I've been tempted).
$green
    Regardless of which option you choose, you should get more bitcoin.
$orange
########################################################################################
"
enter_continue
return 1
    fi

fi
}