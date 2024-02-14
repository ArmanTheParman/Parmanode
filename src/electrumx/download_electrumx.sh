function download_electrumx {
cd $hp
installed_conf_add "electrumx-start"
git clone https://github.com/spesmilo/electrumx.git || return 1
}
