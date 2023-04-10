function partition_drive {


sdrive="/dev/$disk"    #$disk chosen earlier and has the pattern sdX

# Check if the drive exists
if [ ! -e "$sdrive" ] ; then
    set_terminal
    echo "Drive $sdrive does not exist. Exiting."
    enter_continue
    exit 1
fi

# Create a new GPT partition table and a single partition on the drive
# interestingly, you can plonk a redirection in the middle of a heredoc like this:
sudo fdisk "$sdrive" <<EOF >/dev/null 
g
n
1


w
EOF
# The fdisk command makes the output white which I don't like.
# Not sure if anyone knows a better fix. I kind of prefer to to hide the
# standard output as it can be important to some users.

echo "A new GPT partition table and a single partition have been created on $drive."

return 0
}