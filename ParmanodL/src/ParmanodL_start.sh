function ParmanodL_make_systemd_script {

source $HOME/parman_programs/parmanode/src/source_parmanode.sh && source_parmanode
}

function detct_format_or_mount {

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

sudo mount
}

