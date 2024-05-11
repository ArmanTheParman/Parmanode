function download_ParmanodL_image {
while true ; do
set_terminal
set_terminal ; echo -e "
########################################################################################

    There are various ways to get the$cyan ParmanodL-PI-v3.0.0.img$orange file.

$green        t)$orange        Torrent (downloads torrent link to desktop)

$green        dl)$orange       Download img file from archive.org

$green        pt)$orange       Parman's Tor server

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in 
q|Q) exit ;; p|P) return 1 ;; back2main ;;
t)
cp $pn/src/ParmanodL/ParmanodL-PI-v3.0.0.torrent $HOME/Downloads/
announce "
    ParmanodL-PI-v3.0.0.torrent can be found in your Downloads
    directory. Use a program like qBittorrent (available with Parmanode)
    to import it and start downloading. Please leave it open and seed
    for others if you can.

    There is info to read in the torrent file. If you need my public key
    you can get it here: $cyan

    https://armantheparman.com/pubkey $orange

    and like this: $cyan

    gpg --keyserver keyserver.ubuntu.com --recv-key E7C061D4C5E5BC98 $orange

    Use the command $cyan

    tar -xvf ParmanodL-PI-v3.0.0.tar $orange

    to extract the data. You can then flash the .img.gz file with Balena
    Etcher, and you can also verify the signature file. $cyan

    gpg --keyserver keyserver.ubuntu.com --recv-key E7C061D4C5E5BC98 
    gpg --verify ParmanodL-PI-v3.0.0.img.xz.sig ParmanodL-PI-v3.0.0.img.xz
    $orange
    "
return 0
;;
dl)
set_terminal
cd $HOME/Downloads/
curl -LO https://archive.org/download/parmanod-l-pi-v-3.0.0.img/ParmanodL-PI-v3.0.0.img.xz
curl -LO https://archive.org/download/parmanod-l-pi-v-3.0.0.img/ParmanodL-PI-v3.0.0.img.xz.sig
announce "ParmanodL-Pi-v3.0.0.img.xz and the corresponding signature file
    has been downloaded to your Downloads directory.

    You can then flash the .img.gz file with Balena
    Etcher, and you can also verify the signature file. $cyan
    gpg --keyserver keyserver.ubuntu.com --recv-key E7C061D4C5E5BC98 
    gpg --verify ParmanodL-PI-v3.0.0.img.xz.sig ParmanodL-PI-v3.0.0.img.xz
    $orange"
curl -LO
return 0
;;
pt)
announce "The onion address to download this from is here... $bright_blue

    https://7zatnd4wode263mlx5tmvvbyon4ej64noftfp3lloayhiwbogm63kdad.onion:7777/
$orange"
return 0
;;
*)
invalid
;;
esac
done
}
