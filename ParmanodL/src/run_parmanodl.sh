function make_Run_ParmanodL {

# Make execution script

cat << 'EOF' > $HOME/Desktop/Run_ParmanodL
#!/bin/bash

printf '\033[8;38;88t'  

if [[ $(uname) == Darwin ]] ; then
    sed -i '' '/parmanodl.local/d' $HOME/.ssh/known_hosts >/dev/null
fi

if [[ $(uname) == Linux ]] ; then
    sed -i '/parmanodl.local/d' $HOME/.ssh/known_hosts >/dev/null
fi

ssh-keyscan parmanodl.local >> ~/.ssh/known_hosts 2>/dev/null

ssh parman@parmanodl.local
EOF

sudo chmod +x $HOME/Desktop/Run_ParmanodL

}