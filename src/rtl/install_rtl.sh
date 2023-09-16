function install_rtl {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
grep -q docker-end < $HOME/.parmanode/installed.conf || { announce "Must install Docker first. Aborting." && return 1 ; }


#if working on installing on host...
#	install_nodejs 
#download_rtl
#	verify_rtl || return 1
#	extract_rtl
#install_rtl
#fi

if ! which docker >/dev/null ; then 
announce "Sorry, you need Docker first. This will be seemless soon, but for now," \
"Please installed btcpay first to get Docker. Uninstall btcpay later if you want." 
return 1
else
        if ! id | grep -q docker ; then
        announce "Docker is installed but a reboot is required to get the USER into the Docker group." \
        "Please reboot and try installing again."
        return 1
        fi
fi

lncli wallet accounts list >/dev/null 2>&1 || echo "
########################################################################################

    RTL is software that connects to your LND wallet. Parmanode helps by configuring
    the RTL software to point to the Parmanode LND wallet. It seems either that you
    haven't made a LND wallet yet, or it is locked. A wallet is required BEFORE
    installing RTL so that Parmanode can edit the configuration files for you.

    Aborting installation. Please make a wallet and return to installing RTL.

########################################################################################
" && enter_continue && return 1


mkdir $HOME/parmanode/rtl $HOME/parmanode/startup_scripts/ 2>/dev/null
installed_config_add "rtl-start"
make_rtl_config

docker build -t rtl ./src/rtl || { debug1 "failed to build rtl image" && return 1 ; }
docker run -d --name rtl \
                         --network="host" \
                         -v $HOME/parmanode/rtl:/home/parman/RTL2 \
			 -v $HOME/.lnd:/home/parman/.lnd \
                         -v $HOME/.parmanode/:/home/parman/.parmanode \
                         rtl \
        || { debug1 "failed to run rtl image" && return 1 ; }

mv $original_dir/src/rtl/RTL-Config.json $HOME/parmanode/rtl
rtl_password_changer

run_rtl


make_rtl_startup_script

success "RTL" "being installed."
installed_config_add "rtl-end"

}
