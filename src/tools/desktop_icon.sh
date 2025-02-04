function desktop_icon {
file=$HOME/Desktop/xxx

[[ -e $file ]] && { announce "An icon on the desktop alread exits" ; return 1 ; }

yesorno "This will add an icon called 'run parmanode shortcut.sh' on the desktop
    There's no point for Ubuntu users, as Ubuntu doesn't allow desktop icons.

    Continue?" || return 1


cat << 'EOF' > "$file" || { enter_continue "Something went wrong" ; return 1 ; }
#!/usr/bin/env bash 
cd $HOME/parman_programs/parmanode
./run_parmanode.sh
EOF


sudo chmod +x "$file"

if [[ $OS == "Mac" ]] ; then
mv $file "$HOME/Desktop/run parmanode shortcut.command"
else
mv $file "$HOME/Desktop/run parmanode shortcut.sh"
fi

success "A desktop icon has been added. Double-click it to run, and choose to
    run-from-terminal if prompted."

}