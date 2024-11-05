function cleanup_bashrc_zshrc {
#remove bashrc/zshrc additions
sudo gsed -i "/Parmanode.../d" $bashrc  >/dev/null 2>&1
sudo gsed -i "/function rp {/d" $bashrc  >/dev/null 2>&1
sudo gsed -i "/safe to delete/d" $bashrc  >/dev/null 2>&1
sudo gsed -i "/parmashell_functions/d" $bashrc  >/dev/null 2>&1
}