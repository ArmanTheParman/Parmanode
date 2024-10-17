function cleanup_bashrc_zshrc {

#remove bashrc/zshrc additions
delete_line "$HOME/$bashrc" "Parmanode..." >/dev/null 2>&1
delete_line "$HOME/$bashrc" "function rp {" >/dev/null 2>&1
delete_line "$HOME/$bashrc" "safe to delete" >/dev/null 2>&1
delete_line "$HOME/$bashrc" "parmashell_functions" >/dev/null 2>&1
}