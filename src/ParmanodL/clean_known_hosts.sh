function clean_known_hosts {

if [[ $(uname) == Darwin ]] ; then
    sed -i '' '/parmanodl.local/d' $HOME/.ssh/known_hosts >/dev/null
fi

if [[ $(uname) == Linux ]] ; then
    sed -i '/parmanodl.local/d' $HOME/.ssh/known_hosts >/dev/null
fi

}