function download_electrumx {
cd $hp
installed_conf_add "electrumx-start"
git clone --depth 1 https://github.com/spesmilo/electrumx.git || return 1
}
