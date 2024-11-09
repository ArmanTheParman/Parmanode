function fulcrum_install_files {
sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/fulcrum/Ful*/Ful* && \
rm $HOME/parmanode/fulcrum/Ful*/Ful* 
return 0
}