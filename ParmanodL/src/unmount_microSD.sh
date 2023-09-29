function unmount_microSD {

diskutil unmount $disk >/dev/null 2>&1

diskutil unmountDisk $disk >/dev/null 2>&1
    
}