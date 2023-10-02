function ParmanodL_make_systemd_script {

source $HOME/parman_programs/parmanode/src/source_parmanode.sh && source_parmanode
}

function detect_format_or_mount {

#Detect and Format SSD

    if ! sudo blkid | grep parmanode ; then
        if   sudo blkid | grep sda ; then
            format_sda
        fi
    else
    mount_sda
    fi
}

function mount_sda {
cd ~
sudo mount -L parmanode /media/parman/parmanode
}

function unmount_sda {
cd ~ 
sudo umount /media/parman/parmanode
}

