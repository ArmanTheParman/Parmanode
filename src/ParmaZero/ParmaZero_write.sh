function ParmaZero_write {

if [[ $OS == Linux ]] ; then
sudo dd if="${image_path}" of="${disk}" bs=8000000 status=progress 
fi

if [[ $OS == Mac ]] ; then
clear
echo "
Please wait...

"
sudo dd if="${image_path}" of="${disk}" bs=8000000 
fi

sync
}