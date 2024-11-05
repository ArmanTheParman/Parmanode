function cleanup_bashrc_zshrc {
#remove bashrc/zshrc additions
delete_line "$bashrc" "Parmanode..." >/dev/null 2>&1
delete_line "$bashrc" "function rp {" >/dev/null 2>&1
delete_line "$bashrc" "safe to delete" >/dev/null 2>&1
delete_line "$bashrc" "parmashell_functions" >/dev/null 2>&1
}