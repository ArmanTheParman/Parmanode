function cleanup_bashrc_zshrc {
#remove bashrc/zshrc additions
sudo gsed -i "/Parmanode.../d" $bashrc  >$dn 2>&1
sudo gsed -i "/function rp {/d" $bashrc  >$dn 2>&1
sudo gsed -i "/safe to delete/d" $bashrc  >$dn 2>&1
sudo gsed -i "/parmashell_functions/d" $bashrc  >$dn 2>&1
sudo gsed -i "/Added here by ParmaRaid/,/End of ParmaRaid Status/d" $bashrc $dn 2>&1
}