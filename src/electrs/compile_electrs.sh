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
        announce "Compiling seems to have failed. Aborting."
        return 1
    fi
fi
}