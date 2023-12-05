function install_mempool {

if ! grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
announce "Need to install Bitcoin first from Parmanode menu. Aborting." ; return 1 ; fi

if ! docker ps >/dev/null ; then announce "Please install Docker first from Parmanode Add/Other menu, and START it. Aborting." ; return 1 ; fi

# INTRO

cd $hp
git clone --depth 1 https://github.com/mempool/mempool.git
installed_config_add "mempool-start"

#set variables


}