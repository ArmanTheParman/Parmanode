function ParmaZero_unzip {
cd $PZdir
file="$PZdir/*.xz"
xz -vkd $file || { announce "Failed to unzip image file" ; return 1 ; }
export image_file=$(ls *.img)
export image_path="$(pwd)/$image_file"
}