function sudoers_patch {
return 0

echo "
$USER ALL=(root) NOPASSWD: /usr/bin/install -m 0755 -o $USER -t /usr/local/bin *
" | sudo tee -a /etc/sudoers.d/parmaview
}

