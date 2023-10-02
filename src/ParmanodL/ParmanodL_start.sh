function ParmanodL_make_systemd_script {

export drive=external
export prune_value=0
export OS=Linux
export installer=parmanodl

source $HOME/parman_programs/parmanode/src/source_parmanode.sh && source_parmanode

detect_format_or_mount

detect_bitcoin_installation

}

function detect_format_or_mount {

    if ! sudo blkid | grep parmanode ; then
        if   sudo blkid | grep sda ; then
            format_sda
        fi

    else
        if ! mountpoint /media/parman/parmanode ; then mount_sda ; fi
    fi
}

function mount_sda {
cd ~
sudo mount /dev/sda /media/parman/parmanode
sudo chown -R parman:parman /media/parman
}

function unmount_sda {
cd ~ 
sudo umount /dev/sda*
}


function format_sda {
unmount_sda
partition_drive "$installer" 
remove_parmanode_fstab
sudo mkfs.ext4 -F -L "parmanode" $disk 
get_UUID
parmanode_conf_add "UUID=$UUID"
write_to_fstab "$UUID"
}

function label_parmanode_sda {
mount_sda
sudo e2label $disk parmanode 2>&1 
}

function detect_bitcoin_installation {

if ! grep -q bitcoin-end < /home/parman/.parmanode/installed.conf ; then
    ParmanodL_bitcoin_install
fi

}

function ParmanodL_bitcoin_install {

make_bitcoin_directories
download_bitcoin_linux
make_bitcoin_conf
#continue here...
}