function download_eps {
    mkdir -p $hp/eps
    cd $hp/eps || { sww && return 1 ; }
    curl -LO https://github.com/chris-belcher/electrum-personal-server/archive/refs/tags/eps-v0.2.4.tar.gz
    curl -LO https://github.com/chris-belcher/electrum-personal-server/releases/download/eps-v0.2.4/eps-v0.2.4.tar.gz.asc
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 0A8B038F5E10CC2789BFCFFFEF734EA677F31129 >$dn 2>&1
    gpg --verify eps-v0.2.4.tar.gz.asc eps-v0.2.4.tar.gz || { sww && return 1 ; }
    tar -xzf eps-v0.2.4.tar.gz --strip-components=1
    echo "$green"
    echo "Installing EPS with PIP3..."
    { pip3 install --user . || pip3 install --user . --break-system-packages ; } || { sww && yesorno "exit?" && return 1 ; }
    return 0    
}