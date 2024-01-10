# function bitcoin_dependencies {
# while true ; do
# if command -v brew >/dev/null 2>&1
# 	then
# 	true #proceed to install brew
# 	else
#     log "bitcoin" "break from {command -v brew} loop, in bitcoin_dependencies. Brew not installed."
#     break
# 	fi

# while true ; do
# set_terminal
# echo "
# ########################################################################################

#                       Installing dependencies for Bitcoin Core

#     Parmanode needs to install Bitcoin dependencies if you're going to install
#     Bitcoin Core using Parmanode. You can skip this but you may get errors. It may 
#     take 5 to 10 minutes. If all this waiting is getting to you, let that be a lesson 
#     that you should be using Linux! :(   Linux users running Parmanode would 
#     already have begun syncing the blockchain by now, just saying. To learn Linux, a 
#     great book to get started is \"The Command Line Book\" by William Shotts, 5th 
#     internet edition, free PDF.

# 				<enter>    Install dependencies
				
# 				s)         Skip

# ########################################################################################
# "
# choose "x" ; read choice

# if [[ $choice == "s" ]] ; then break 2 ; fi
# if [[ $choice == "" ]] ; then break ; fi
# invalid
# done

# # while loop breaks to here
# please_wait
# brew install automake libtool boost pkg-config libevent zeromq berkeley-db@4 && \
# installed_conf_add "btc_dependencies" && \
# return 0 
# done

# #break 2 comes here (skip installation) - will lead to a return 1 

# #for silicon chip macs, needs to add brew to path

# if [[ $(uname -m) == "arm64" ]] ; then
# echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)" >/dev/null
# set_terminal
# return 1 
# fi

# return 1
# }


