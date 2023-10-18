function get_Mint {

cd $HOME/ParmanodL

    curl -LO https://mirrors.seas.harvard.edu/linuxmint/stable/21.2/linuxmint-21.2-cinnamon-64bit.iso
    curl -LO https://ftp.heanet.ie/mirrors/linuxmint.com/stable/21.2/sha256sum.txt
    curl -LO https://ftp.heanet.ie/mirrors/linuxmint.com/stable/21.2/sha256sum.txt.gpg

}

function verify_Mint {

    gpg --import $HOME/parman_programs/parmanode/ParmanodL/Linux_mint.pubkey

if ! gpg --verify --status-fd 1 sha256sum.txt.gpg >/dev/null 2>&1 | grep -q GOOD ; then
announce "gpg verification failed. Aborting."
return 1
fi

}
