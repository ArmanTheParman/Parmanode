function sudoers_patch {
return 0

echo "
$USER ALL=(root) NOPASSWD: grep *
$USER ALL=(root) NOPASSWD: apt-get install tor
" | sudo tee -a /etc/sudoers.d/parmaview
}

