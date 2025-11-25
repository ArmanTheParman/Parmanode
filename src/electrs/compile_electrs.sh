function compile_electrs {
set_terminal ; echo "   Compiling electrs..."
please_wait ; echo ""
[[ $OS == "Mac" ]] && export LIBCLANG_PATH=$(brew --prefix llvm)/lib 
cd $HOME/parmanode/electrs && cargo build --locked --release > $tmp/cargo_build.log
if [[  ! -e $HOME/parmanode/electrs/target/release/electrs ]] ; then
    if grep -q "perhaps you ran out of disk space" $tmp/cargo_build.log ; then 
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
$cyan
        1)$orange Uninstall this partial installation yourself from the remove menu, 
           and try again (sometimes works)
$cyan
        2)$orange Uninstall this partial installation yourself, and install the Docker
           version of electrs instead. Docker is a container with an operating system
           which which is identical between systems, reduces chances of installation
           failure.
$cyan    
        3)$orange Install Fulcrum or Electrum X instead of electrs
$cyan
        4)$orange Put computer in the bin (I've been tempted).
$green
    Regardless of which option you choose, you should get more bitcoin.
$orange
########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi

fi
}