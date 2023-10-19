# function download_rtl {

# cd $HOME/parmanode
# curl -LO https://github.com/Ride-The-Lightning/RTL/archive/refs/tags/v0.13.6.tar.gz
# crul -LO https://github.com/Ride-The-Lightning/RTL/releases/download/v0.13.6/v0.13.6.tar.gz.asc

# }


# function verify_rtl {
# cd $HOME/parmanode
# curl https://keybase.io/suheb/pgp_keys.asc | gpg --import

# if ! gpg --verify v0.13*.asc v0.13*.gz ; then
# 	set_terminal
# 	echo "GPG verification failed. Aborting."
# 	enter_continue
#         return 1
# 	fi
# }

# function extract_rtl {
# cd $HOME/parmanode
# tar -xvf v0.13*.gz 
# mv RTL-* RTL
# }


