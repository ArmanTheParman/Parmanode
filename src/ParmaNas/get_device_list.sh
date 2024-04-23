function get_device_list {
# Initialize an empty string to hold the device names
device_list=""

# Read each line in the device_list.conf file
while IFS= read -r line; do
    # Append each device name to the string
    device_list+="$line "
done < "$dp/device_list.conf"
}