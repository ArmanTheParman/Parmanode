function update_lnd {
if [[ $lnd_version == "0.17.0" ]] ; then announce "Already have version 0.17.0." ; return 1 ; fi

while true ; do
clear
echo -e "
########################################################################################

    The LND binary files will be moved to a backup location, and new LND binary files
    from version 0.17.0 will be installed.

    Your LND data will not be affected.

    Continue?    y    or    n

########################################################################################
"
choose "xpmq" ; read choice

case $choice in q|Q) quit ;; p|P|N|NO|No|n) return 1 ;;
m) back2main ;;
y|Y|Yes|YES) break ;;
*) invalid ;;
esac
done

stop_lnd

cd $HOME/parmanode/lnd
rm -rf ./*
cd $HOME/parmanode

download_lnd
verify_lnd || return 1
unpack_lnd

sudo mkdir $HOME/parmanode/lnd_old_binaries >/dev/null 2>&1
sudo mv /usr/local/bin/lnd-* $HOME/parmanode/lnd_old_binaries >/dev/null 2>&1
sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/lnd/lnd-*/* >/dev/null 2>&1

success "LND" "being updated"
start_lnd
}