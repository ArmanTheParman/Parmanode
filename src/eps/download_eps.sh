function download_eps {
    mkdir -p $hp/eps
    cd $hp/eps || sww && return 1
    curl -LO https://github.com/chris-belcher/electrum-personal-server/archive/refs/tags/eps-v0.2.4.tar.gz
    curl -LO https://github.com/chris-belcher/electrum-personal-server/releases/download/eps-v0.2.4/eps-v0.2.4.tar.gz.asc
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 658E64021E5793C6C4E15E45C2E581F5B998F30E >$dn 2>&1
    gpg -- verirfy eps-v0.2.4.tar.gz.asc eps-v0.2.4.tar.gz || sww && return 1
    tar -xzf eps-v0.2.4.tar.gz --strip-components=1
    echo "$green"
    echo "Installing EPS with PIP3..."
    pip3 install --user . && sww && yesorno "exit?" && return 1
    
}